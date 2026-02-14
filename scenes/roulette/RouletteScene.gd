extends Control

@onready var image_clip := $VerticalLayout/ImageClip
@onready var image_rect := $VerticalLayout/ImageClip/ImageRect
@onready var image_count_label := $VerticalLayout/MarginContainer/ToolBar/ImageCountLabel
@onready var current_path_label := $VerticalLayout/MarginContainer/ToolBar/CurrentPathLabel
@onready var next_button := $VerticalLayout/MarginContainer/ToolBar/NextButton
@onready var timer_label := $VerticalLayout/MarginContainer/ToolBar/TimerLabel
@onready var timer := $Timer
@onready var more_time_menu := $MoreTimeMenu
@onready var add_time_button := $VerticalLayout/MarginContainer/ToolBar/AddTimeButton
@onready var pause_play_button := $VerticalLayout/MarginContainer/ToolBar/PausePlayButton
@onready var session_timer_label := $VerticalLayout/MarginContainer/ToolBar/SessionTimerLabel
@onready var session_timer := $SessionTimer
@onready var session_dialog := $ConfirmationDialog

var zoom_level := 1.0
var pan_offset := Vector2.ZERO
var last_mouse_pos := Vector2.ZERO

const ZOOM_MIN := 1.0
const ZOOM_MAX := 5.0
const ZOOM_STEP := 0.15
const PINCH_SENSITIVITY := 5.0
const PAN_SENSITIVITY := 10.0

func _reset_zoom():
	zoom_level = 1.0
	pan_offset = Vector2.ZERO
	image_rect.scale = Vector2.ONE
	image_rect.position = Vector2.ZERO

func _apply_zoom():
	image_rect.scale = Vector2.ONE * zoom_level
	image_rect.position = pan_offset

func _zoom_at(mouse_pos: Vector2, step: float):
	var old_zoom = zoom_level
	zoom_level = clampf(zoom_level + step, ZOOM_MIN, ZOOM_MAX)
	if zoom_level == old_zoom:
		return

	# Adjust pan so the point under the cursor stays fixed
	var focus = (mouse_pos - pan_offset) / old_zoom
	pan_offset = mouse_pos - focus * zoom_level

	# Snap back to origin when fully zoomed out
	if zoom_level == ZOOM_MIN:
		pan_offset = Vector2.ZERO

	_apply_zoom()


func _input(event):
	if event is InputEventMagnifyGesture:
		var step = (event.factor - 1.0) * ZOOM_STEP * PINCH_SENSITIVITY
		_zoom_at(image_clip.get_local_mouse_position(), step)
	elif event is InputEventPanGesture and zoom_level > ZOOM_MIN:
		pan_offset -= event.delta * PAN_SENSITIVITY
		_apply_zoom()

func get_next():
	_reset_zoom()

	var image_path = FileBrowser.pop_next()
	if image_path == "":
		image_rect.texture = null
		current_path_label.text = "NO IMAGES LEFT"
		next_button.disabled = true
		return
	
	# Show the number remaining
	image_count_label.text = "%d / %d left" % [FileBrowser.image_paths.size(), FileBrowser.total_images_loaded]
	
	# Load the image
	var disp_path = image_path.replace(FileBrowser.root_directory, "")
	var image = Image.load_from_file(image_path)
	if image != null:
		var texture = ImageTexture.create_from_image(image)
		image_rect.texture = texture
		current_path_label.text = disp_path
	
	# Start the timer
	if TimeManager.selected_duration != TimeManager.UNLIMITED:
		timer.wait_time = TimeManager.time_in_seconds(TimeManager.selected_duration)
		timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_next()

	# Start the session timer
	if TimeManager.selected_session_duration != TimeManager.SESSION_UNLIMITED:
		session_timer.wait_time = TimeManager.session_in_seconds(TimeManager.selected_session_duration)
		session_timer.start()

	session_timer.timeout.connect(_on_session_timer_timeout)
	session_dialog.confirmed.connect(_on_session_dialog_confirmed)
	session_dialog.canceled.connect(_on_session_dialog_canceled)

func timer_readout(time_left: float) -> String:
	var minutes = int(time_left / 60)
	var seconds = int(time_left) - (minutes * 60)
	return "%02d:%02d" % [minutes, seconds]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("skip"):
		get_next()

	if Input.is_action_just_pressed("zoom_in"):
		_zoom_at(image_clip.get_local_mouse_position(), ZOOM_STEP)
	elif Input.is_action_just_pressed("zoom_out"):
		_zoom_at(image_clip.get_local_mouse_position(), -ZOOM_STEP)

	var current_mouse_pos = get_viewport().get_mouse_position()
	if Input.is_action_pressed("l_click") and zoom_level > ZOOM_MIN:
		pan_offset += current_mouse_pos - last_mouse_pos
		_apply_zoom()
	last_mouse_pos = current_mouse_pos
	
	if TimeManager.selected_duration != TimeManager.UNLIMITED:
		timer_label.text = timer_readout(timer.time_left)
		timer_label.modulate = Color.GREEN_YELLOW if timer.time_left > 15.0 else Color.RED
	
	if TimeManager.selected_session_duration != TimeManager.SESSION_UNLIMITED:
		session_timer_label.text = timer_readout(session_timer.time_left)
		session_timer_label.modulate = Color.GREEN_YELLOW if session_timer.time_left > 60.0 else Color.RED

func _on_done_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_tree().change_scene_to_file("res://scenes/setup/SetupScene.tscn")

func _on_next_button_pressed():
	get_next()


func _on_focus_button_toggled(button_pressed):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if button_pressed else DisplayServer.WINDOW_MODE_WINDOWED)


func _on_timer_timeout():
	get_next()


func _on_add_time_button_pressed():
	more_time_menu.popup(Rect2(add_time_button.position + Vector2(0, add_time_button.get_rect().size.y), Vector2(200, 300)))
	# popup_menu.popup(button_position + Vector2(0, $Button.rect_size.y))


func _on_more_time_menu_index_pressed(index):
	var amt: float = 0
	match index:
		0:
			amt = 60
		1:
			amt = 120
		2:
			amt = 5 * 60
		3:
			amt = 10 * 60
		4:
			amt = 20 * 60
	timer.wait_time = timer.time_left + amt
	timer.start()


func _on_pause_play_button_pressed():
	timer.paused = !timer.paused
	session_timer.paused = timer.paused
	pause_play_button.text = "Resume" if timer.paused else "Pause"

func _on_session_timer_timeout():
	timer.paused = true
	session_timer.paused = true
	session_dialog.popup_centered()

func _on_session_dialog_confirmed():
	# "I'm Finished" — go back to setup
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_tree().change_scene_to_file("res://scenes/setup/SetupScene.tscn")

func _on_session_dialog_canceled():
	# "Continue Drawing" — unpause and keep going
	timer.paused = false
	session_timer.paused = false
