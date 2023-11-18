extends Control

@onready var image_rect := $VerticalLayout/ImageRect
@onready var image_count_label := $VerticalLayout/MarginContainer/ToolBar/ImageCountLabel
@onready var current_path_label := $VerticalLayout/MarginContainer/ToolBar/CurrentPathLabel
@onready var next_button := $VerticalLayout/MarginContainer/ToolBar/NextButton
@onready var timer_label := $VerticalLayout/MarginContainer/ToolBar/TimerLabel
@onready var timer := $Timer

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("skip"):
		get_next()
	
	if TimeManager.selected_duration != TimeManager.UNLIMITED:
		var time_left = timer.time_left
		var minutes = int(time_left / 60)
		var seconds = int(time_left) - (minutes * 60)
		timer_label.text = "%02d:%02d" % [minutes, seconds]
		timer_label.modulate = Color.GREEN_YELLOW if time_left > 15.0 else Color.RED

func _on_done_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_tree().change_scene_to_file("res://scenes/setup/SetupScene.tscn")

func _on_next_button_pressed():
	get_next()


func _on_focus_button_toggled(button_pressed):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if button_pressed else DisplayServer.WINDOW_MODE_WINDOWED)


func _on_timer_timeout():
	get_next()
