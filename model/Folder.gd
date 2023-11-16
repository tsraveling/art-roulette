extends Object
class_name Folder

var path: String
var display_path: String
var included: bool = true

func _init(path: String, included: bool = true):
	self.path = path
	self.included = included
	self.display_path = path.replace(FileBrowser.root_directory, "")
