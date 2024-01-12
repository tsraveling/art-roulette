extends Control

@onready var image_rect := $VerticalLayout/ImageRect
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

# STUB: On pick, pop the picked image and put it in a "done" array
# STUB: Add timers
# STUB: Clicking a checkbox on or off

func get_next():
	
	var image_path = FileBrowser.pop_next()
	if image_path == "":
		image_rect.texture = null
		current_path_label.text = "NO IMAGES LEFT"
		next_button.disabled = true
		return
	
	# Show the number remaining
	image_count_label.text = "%d / %d left" % [FileBrowser.image_paths.size(), FileBrowser.total_images_loaded]
	
	# Load the image
	var disp_path = image_path.replace(Config.library_root, "")
	var image = Image.load_from_file(image_path)
	if image != null:
		var texture = ImageTexture.create_from_image(image)
		image_rect.texture = texture
		current_path_label.text = disp_path
	
	# Start the timer
	if Session.selected_duration != Session.UNLIMITED:
		timer.wait_time = Session.time_in_seconds(Session.selected_duration)
		timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_next()
	
	# Start the session otimer
	if Session.selected_session_duration != Session.SESSION_UNLIMITED:
		session_timer.wait_time = Session.session_in_seconds(Session.selected_session_duration)
		session_timer.start()

func timer_readout(time_left: float) -> String:
	var minutes = int(time_left / 60)
	var seconds = int(time_left) - (minutes * 60)
	return "%02d:%02d" % [minutes, seconds]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("skip"):
		get_next()
	
	if Session.selected_duration != Session.UNLIMITED:
		timer_label.text = timer_readout(timer.time_left)
		timer_label.modulate = Color.GREEN_YELLOW if timer.time_left > 15.0 else Color.RED
	
	if Session.selected_session_duration != Session.SESSION_UNLIMITED:
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
