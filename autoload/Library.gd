extends Node

const LIBRARY_FILE := ".arlibrary"

var db

func set_new_root(dir):
	print(">>> set library root: %s" % dir)
	Config.library_root = dir
	Config.save_config()
	load_library()

func process_dir(path, image_list):
	print(">>> %s (%d)" % [path, image_list.size()])
	# STUB: Add a record or retreive the folder with this path (might require index)
	# STUB: Add a record for each image in image_list if it doesn't exist already

func load_library():
	var library_path = "%s/%s" % [Config.library_root, LIBRARY_FILE]
	print(">>> loading library file: %s" % library_path)
	
	# Initialize the SQLite database
	db = SQLite.new()
	db.path = library_path
	db.open_db()

	# Create the database
	db.query(Queries.CREATE_FOLDERS)
	db.query(Queries.CREATE_IMAGES)
	db.query(Queries.CREATE_TAGS)
	db.query(Queries.CREATE_IMAGE_TAGS)
	db.query(Queries.CREATE_MIGRATIONS)
	
	# TODO: Make this async at some point.
	FileBrowser.scan_dir(Config.library_root, process_dir)

	# Additional logic to check if this is the first run can be implemented here
	# For instance, you could check for the existence of any records in the tables

	# Close the database if not in use immediately
	db.close_db()

func _ready():
	if Config.library_root != "":
		load_library()
	else:
		# STUB: So show us the different UI instead
		print(">>> no library root found")
