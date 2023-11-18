extends Object
class_name Folder

var path: String
var display_path: String
var included: bool = true
var image_paths: Array[String]
var image_count: int

func _init(path: String, included: bool = true):
	self.path = path
	self.included = included
	self.display_path = path.replace(FileBrowser.root_directory, "")
	self.image_paths = get_images()
	self.image_count = self.image_paths.size()

func get_images() -> Array[String]:
	var ret: Array[String] = []
	var base_dir = DirAccess.open(path)
	if base_dir:
		base_dir.list_dir_begin()
		var file_name = base_dir.get_next()
		while file_name != "":
			if !base_dir.current_is_dir() && (file_name.ends_with(".png") || file_name.ends_with(".jpg") || file_name.ends_with(".jpeg")):
				ret.append("%s/%s" % [path, file_name])
			file_name = base_dir.get_next()
	else:
		print("Error occurred while trying to access path: %s" % base_dir)
	return ret
