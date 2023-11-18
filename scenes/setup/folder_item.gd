extends CheckBox

var attached_folder: Folder

func update_ui():
	if attached_folder == null:
		return
	self.button_pressed = attached_folder.included
	var path = attached_folder.display_path if attached_folder.display_path.length() > 0 else "/"
	self.text = "%s (%d images)" % [path, attached_folder.image_count]

func set_folder(folder: Folder):
	attached_folder = folder
	update_ui()

func _ready():
	update_ui()

func _on_toggled(button_pressed):
	attached_folder.included = button_pressed
