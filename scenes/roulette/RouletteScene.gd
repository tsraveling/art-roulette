extends Control

@onready var root_dir_picker := $RootDirectoryPicker
@onready var root_dir_button := $VBoxContainer/HBoxContainer/RootDirectoryButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_root_directory_button_pressed():
	root_dir_picker.popup_centered(Vector2(600, 400))


func _on_root_directory_picker_dir_selected(dir):
	root_dir_button.text = dir
