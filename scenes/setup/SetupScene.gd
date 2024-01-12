extends Control

@onready var root_dir_picker := $RootDirectoryPicker
@onready var root_dir_button := $VerticalLayout/RootDirSelector/RootDirectoryButton
@onready var folder_list := $VerticalLayout/ScrollContainer/VBoxContainer/FolderList
@onready var duration_select := $VerticalLayout/IntervalHBox/OptionButton
@onready var session_select := $VerticalLayout/SessionHBox/SessionDurationButton
@onready var change_root_confirm := $ChangeRootConfirmDialog

var folder_item = preload("res://scenes/setup/folder_item.tscn")
var requested_root_change: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	root_dir_button.text = Config.library_root
	duration_select.selected = Session.selected_duration
	session_select.selected = Session.selected_session_duration
	refresh_list()

func _on_root_directory_button_pressed():
	if Config.library_root != "":
		root_dir_picker.current_path = Config.library_root
	root_dir_picker.popup_centered(Vector2(800, 400))

func refresh_list():
	
	# Clear out the old list
	for child in folder_list.get_children():
		child.queue_free()
	
	# Add the new babies
	for folder in FileBrowser.folders:
		var list_item = folder_item.instantiate()
		list_item.set_folder(folder)
		folder_list.add_child(list_item)	

func _on_root_directory_picker_dir_selected(dir):
	requested_root_change = dir
	change_root_confirm.show()

func _on_start_button_pressed():
	if !FileBrowser.initialized:
		return
	FileBrowser.load_active_images()
	get_tree().change_scene_to_file("res://scenes/roulette/RouletteScene.tscn")


func _on_option_button_item_selected(index):
	Session.selected_duration = index

func _on_session_duration_button_item_selected(index):
	Session.selected_session_duration = index

func _on_change_root_confirm_dialog_confirmed():
	root_dir_button.text = requested_root_change
	Library.set_new_root(requested_root_change)
	refresh_list()
