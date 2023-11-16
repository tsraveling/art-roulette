extends Control

@onready var root_dir_picker := $RootDirectoryPicker
@onready var root_dir_button := $VBoxContainer/HBoxContainer/RootDirectoryButton
@onready var folder_scroller := $VBoxContainer/FolderScroller

# Called when the node enters the scene tree for the first time.
func _ready():
	root_dir_button.text = FileBrowser.root_directory


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_root_directory_button_pressed():
	root_dir_picker.popup_centered(Vector2(800, 400))


func _on_root_directory_picker_dir_selected(dir):
	root_dir_button.text = dir
	FileBrowser.set_new_root(dir)
