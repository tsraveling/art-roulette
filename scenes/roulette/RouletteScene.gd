extends Control

@onready var image_rect := $VerticalLayout/ImageRect
@onready var image_count_label := $VerticalLayout/ToolBar/ImageCountLabel
@onready var current_path_label := $VerticalLayout/ToolBar/CurrentPathLabel

func get_next():
	if FileBrowser.image_paths.size() == 0:
		image_rect.texture = null
		current_path_label.text = "NO IMAGES"
		return
	
	var image_index = randi() % FileBrowser.image_paths.size()
	var image_path = FileBrowser.image_paths[image_index]
	var image = Image.load_from_file(image_path)
	if image != null:
		var texture = ImageTexture.create_from_image(image)
		image_rect.texture = texture
		current_path_label.text = image_path
	else:
		current_path_label.text = "INVALID IMAGE: %s" % image_path

# Called when the node enters the scene tree for the first time.
func _ready():
	image_count_label.text = "%d images" % FileBrowser.image_paths.size()
	get_next()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_done_button_pressed():
	get_tree().change_scene_to_file("res://scenes/setup/SetupScene.tscn")


func _on_next_button_pressed():
	get_next()
