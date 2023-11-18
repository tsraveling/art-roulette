extends Control

@onready var image_rect := $VerticalLayout/ImageRect
@onready var image_count_label := $VerticalLayout/MarginContainer/ToolBar/ImageCountLabel
@onready var current_path_label := $VerticalLayout/MarginContainer/ToolBar/CurrentPathLabel
@onready var next_button := $VerticalLayout/MarginContainer/ToolBar/NextButton

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
	
	image_count_label.text = "%d / %d left" % [FileBrowser.image_paths.size(), FileBrowser.total_images_loaded]
	
	var disp_path = image_path.replace(FileBrowser.root_directory, "")
	var image = Image.load_from_file(image_path)
	if image != null:
		var texture = ImageTexture.create_from_image(image)
		image_rect.texture = texture
		current_path_label.text = disp_path

# Called when the node enters the scene tree for the first time.
func _ready():
	get_next()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("skip"):
		get_next()

func _on_done_button_pressed():
	get_tree().change_scene_to_file("res://scenes/setup/SetupScene.tscn")

func _on_next_button_pressed():
	get_next()


func _on_focus_button_toggled(button_pressed):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if button_pressed else DisplayServer.WINDOW_MODE_WINDOWED)
