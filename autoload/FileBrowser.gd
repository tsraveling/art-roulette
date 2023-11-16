extends Node

var root_directory: String = "Pick a folder"
var folders: Array[Folder] = []

func save_root():
	var config = ConfigFile.new()
	print(">>> saving ....")
	config.set_value("root", "root_directory", root_directory)
	config.save("user://settings.cfg")

func set_new_root(dir):
	print(">>> set root: %s" % dir)
	root_directory = dir
	save_root()
	load(root_directory)


func load(dir):
		
	# Remove the old folders out of here
	folders.clear()
	
	print(">>> loading %s" % dir)
	# Recurse through the newly selected dir and get paths for each
	var root_dir = DirAccess.open(root_directory)
	if root_dir:
		root_dir.list_dir_begin()
		var file_name = root_dir.get_next()
		while file_name != "":
			if root_dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = root_dir.get_next()
	else:
		print("Error occurred while trying to access path: %s" % root_dir)

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
		load(saved_root)
