extends Node

var root_directory: String = "Pick a folder"
var folders: Array[Folder] = []
var image_paths: Array[String] = []
var initialized := false

func save_root():
	var config = ConfigFile.new()
	print(">>> saving ....")
	config.set_value("root", "root_directory", root_directory)
	config.save("user://settings.cfg")

func set_new_root(dir):
	print(">>> set root: %s" % dir)
	root_directory = dir
	save_root()
	load_root_dir()

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
			else:
				print("Found file: " + file_name)
			file_name = base_dir.get_next()
	else:
		print("Error occurred while trying to access path: %s" % base_dir)
	return ret

func load_root_dir():
	# Remove the old folders out of here
	folders.clear()
	initialized = true
	folders = process_dir(root_directory)

func load_active_images():
	image_paths.clear()
	for folder in folders:
		if folder.included:
			image_paths.append_array(folder.image_paths)
	print("Loaded %d images" % image_paths.size())

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
		print("Loaded root: %s", saved_root)
		load_root_dir()
