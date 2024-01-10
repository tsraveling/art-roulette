extends Node

var root_directory: String = "Pick a folder"
var folders: Array[Folder] = []
var image_paths: Array[String] = []
var image_paths_skipped: Array[String] = []
var image_paths_done: Array[String] = []
var total_images_loaded: int = 0
var initialized := false
var is_root_initialized := false


func process_dir(dir) -> Array[Folder]:
	print("Processing directory: %s" % dir)
	var ret: Array[Folder] = [Folder.new(dir)]
	var base_dir = DirAccess.open(dir)
	if base_dir:
		base_dir.list_dir_begin()
		var file_name = base_dir.get_next()
		while file_name != "":
			if base_dir.current_is_dir():
				print("Found directory: " + file_name)
				ret.append_array(process_dir("%s/%s" % [dir, file_name]))
			file_name = base_dir.get_next()
	else:
		print("Error occurred while trying to access path: %s" % base_dir)
	
	return ret

func load_active_images():
	image_paths.clear()
	image_paths_skipped.clear()
	image_paths_done.clear()
	for folder in folders:
		if folder.included:
			image_paths.append_array(folder.image_paths)
	total_images_loaded = image_paths.size()
	print("Loaded %d images" % total_images_loaded)

# STUB: Move this into library -- maybe even a "Session" autoload
func pop_next(did_finish: bool = true) -> String:
	
	# Ensure the array is not empty to avoid errors
	if image_paths.size() == 0:
		return ""  # or handle the empty array case as needed

	var image_index = randi() % image_paths.size()
	var selected_image = image_paths[image_index]

	# Remove the selected item from the array
	image_paths.remove_at(image_index)
	
	# Add the image to the correct array
	if did_finish:
		image_paths_done.append(selected_image)
	else:
		image_paths_skipped.append(selected_image)

	return selected_image

func _ready():
	var config = ConfigFile.new()
	
	# Load data from a file.
	var err = config.load("user://settings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		print("No config file found, starting fresh.")
		return
	
	# Get the root dir
	var saved_root = config.get_value("root", "root_directory")
	if saved_root != null:
		root_directory = saved_root
		is_root_initialized = true
		print("Loaded root: %s", saved_root)
		# load_root_dir()
