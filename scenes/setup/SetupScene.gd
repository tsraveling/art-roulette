extends Control

@onready var root_dir_picker := $RootDirectoryPicker
@onready var root_dir_button := $VerticalLayout/RootDirSelector/RootDirectoryButton
@onready var duration_select := $VerticalLayout/IntervalHBox/OptionButton
@onready var session_select := $VerticalLayout/SessionHBox/SessionDurationButton
@onready var folder_tree := $VerticalLayout/FolderTree
@onready var ui_scale_slider := $VerticalLayout/UIScaleHBox/UIScaleSlider
@onready var ui_scale_label := $VerticalLayout/UIScaleHBox/UIScaleLabel

var _updating_tree := false

func _ready():
	root_dir_button.text = FileBrowser.root_directory
	duration_select.selected = TimeManager.selected_duration
	session_select.selected = TimeManager.selected_session_duration
	folder_tree.item_edited.connect(_on_folder_tree_item_edited)
	ui_scale_slider.value = FileBrowser.ui_scale
	ui_scale_label.text = "%sx" % str(FileBrowser.ui_scale)
	refresh_list()

func _on_root_directory_button_pressed():
	if FileBrowser.initialized:
		root_dir_picker.current_path = FileBrowser.root_directory
	root_dir_picker.popup_centered(Vector2(800, 400))

func refresh_list():
	folder_tree.clear()

	if FileBrowser.folders.is_empty():
		return

	# The Tree's internal root IS our root folder item
	var tree_root = folder_tree.create_item()
	folder_tree.hide_root = false

	# Map full directory path -> TreeItem so children can find their parent
	var path_to_item: Dictionary = {}

	for folder in FileBrowser.folders:
		if folder.path == FileBrowser.root_directory:
			# Root folder
			_setup_tree_item(tree_root, folder, "/")
			path_to_item[folder.path] = tree_root
		else:
			# Find parent TreeItem by looking up the parent directory path
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

	# Update this item's folder
	var folder := item.get_metadata(0) as Folder
	if folder:
		folder.included = checked

	if checked:
		# Checking a box: select all children, and ensure ancestors are checked
		_set_children_checked(item, true)
		_ensure_parents_checked(item)
	else:
		# Unchecking a box: deselect all children
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
