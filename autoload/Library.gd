extends Node

const LIBRARY_FILE := ".arlibrary"

func set_new_root(dir):
	print(">>> set library root: %s" % dir)
	Config.library_root = dir
	Config.save_config()
	load_library()

func load_library():
	var library_path = "%s/%s" % [Config.library_root, LIBRARY_FILE]
	print(">>> loading library file: %s" % library_path)
	
	Db.initialize_in_root(library_path)
	
	# TODO: Make this async at some point.
	Db.begin()
	FileBrowser.scan_dir(Config.library_root, null)
	Db.end()
	# STUB: Collect all of the folders here, and do an SQL query at the end to see if we are missing anything

	# Additional logic to check if this is the first run can be implemented here
	# For instance, you could check for the existence of any records in the tables

func _ready():
	if Config.library_root != "":
		load_library()
	else:
		# STUB: So show us the different UI instead
		print(">>> no library root found")
