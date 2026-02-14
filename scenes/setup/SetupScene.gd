extends Control

@onready var root_dir_picker := $RootDirectoryPicker
@onready var root_dir_button := $MainLayout/SettingsPanel/RootDirSelector/RootDirectoryButton
@onready var duration_select := $MainLayout/SettingsPanel/IntervalHBox/OptionButton
@onready var session_select := $MainLayout/SettingsPanel/SessionHBox/SessionDurationButton
@onready var folder_tree := $MainLayout/SettingsPanel/FolderTree
@onready var ui_scale_slider := $MainLayout/SettingsPanel/UIScaleHBox/UIScaleSlider
@onready var ui_scale_label := $MainLayout/SettingsPanel/UIScaleHBox/UIScaleLabel
@onready var description_label := $MainLayout/VariationsPanel/DescriptionLabel

const MODE_DESCRIPTIONS := {
	FileBrowser.RouletteMode.STANDARD:
		"Draw photos at random from all selected folders and display one at a time.",
	FileBrowser.RouletteMode.STUDY:
		"Out of the selected folders, choose one that contains more than one photo (not including subfolders) and serve photos only from that folder for the whole session. Use this to study a single model, architectural style, or whatever else underlies your folder structure.",
}

var _updating_tree := false

func _ready():
	root_dir_button.text = FileBrowser.root_directory
	duration_select.selected = TimeManager.selected_duration
	session_select.selected = TimeManager.selected_session_duration
	folder_tree.item_edited.connect(_on_folder_tree_item_edited)
	ui_scale_slider.value = FileBrowser.ui_scale
	ui_scale_label.text = "%sx" % str(FileBrowser.ui_scale)
	description_label.text = MODE_DESCRIPTIONS[FileBrowser.selected_mode]
	refresh_list()

func _on_root_directory_button_pressed():
	if FileBrowser.initialized:
		root_dir_picker.current_path = FileBrowser.root_directory
	root_dir_picker.popup_centered(Vector2(800, 400))

func refresh_list():
	folder_tree.clear()

	if FileBrowser.folders.is_empty():
		return

	var tree_root = folder_tree.create_item()
	folder_tree.hide_root = false

	var path_to_item: Dictionary = {}

	for folder in FileBrowser.folders:
		if folder.path == FileBrowser.root_directory:
			_setup_tree_item(tree_root, folder, "/")
			path_to_item[folder.path] = tree_root
		else:
			var parent_path := folder.path.get_base_dir()
			var parent_item: TreeItem = path_to_item.get(parent_path, tree_root)

			var item = folder_tree.create_item(parent_item)
			_setup_tree_item(item, folder, folder.path.get_file())
			path_to_item[folder.path] = item

func _setup_tree_item(item: TreeItem, folder: Folder, label: String):
	item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
	item.set_editable(0, true)
	item.set_checked(0, folder.included)
	item.set_text(0, "%s (%d images)" % [label, folder.image_count])
	item.set_metadata(0, folder)

func _on_folder_tree_item_edited():
	if _updating_tree:
		return
	_updating_tree = true

	var item = folder_tree.get_edited()
	var checked = item.is_checked(0)

	var folder := item.get_metadata(0) as Folder
	if folder:
		folder.included = checked

	if checked:
		_set_children_checked(item, true)
		_ensure_parents_checked(item)
	else:
		_set_children_checked(item, false)

	_updating_tree = false

func _set_children_checked(item: TreeItem, checked: bool):
	var child := item.get_first_child()
	while child:
		child.set_checked(0, checked)
		var child_folder := child.get_metadata(0) as Folder
		if child_folder:
			child_folder.included = checked
		_set_children_checked(child, checked)
		child = child.get_next()

func _ensure_parents_checked(item: TreeItem):
	var parent := item.get_parent()
	if parent and not parent.is_checked(0):
		parent.set_checked(0, true)
		var parent_folder := parent.get_metadata(0) as Folder
		if parent_folder:
			parent_folder.included = true
		_ensure_parents_checked(parent)

func _on_standard_radio_pressed():
	FileBrowser.selected_mode = FileBrowser.RouletteMode.STANDARD
	description_label.text = MODE_DESCRIPTIONS[FileBrowser.RouletteMode.STANDARD]

func _on_study_radio_pressed():
	FileBrowser.selected_mode = FileBrowser.RouletteMode.STUDY
	description_label.text = MODE_DESCRIPTIONS[FileBrowser.RouletteMode.STUDY]

func _on_root_directory_picker_dir_selected(dir):
	root_dir_button.text = dir
	FileBrowser.set_new_root(dir)
	refresh_list()

func _on_start_button_pressed():
	if !FileBrowser.initialized:
		return
	FileBrowser.load_active_images()
	get_tree().change_scene_to_file("res://scenes/roulette/RouletteScene.tscn")

func _on_option_button_item_selected(index):
	TimeManager.selected_duration = index

func _on_session_duration_button_item_selected(index):
	TimeManager.selected_session_duration = index

func _on_ui_scale_slider_value_changed(value: float):
	ui_scale_label.text = "%sx" % str(value)
	FileBrowser.set_ui_scale(value)
