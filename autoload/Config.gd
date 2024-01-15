extends Node

const SETTINGS_FILE = "user://settings.cfg"
const APP_SECTION = "app"
const LIBRARY_ROOT = "library_root"

const DEBUG_RESET_CONFIG := false

var library_root: String = ""

func save_config():
	var config = ConfigFile.new()
	config.set_value(APP_SECTION, LIBRARY_ROOT, library_root)
	config.save(SETTINGS_FILE)

func delete_config():
	if FileAccess.file_exists(SETTINGS_FILE):
		var error = DirAccess.remove_absolute(SETTINGS_FILE)
		# Check if the file was deleted successfully
		if error == OK:
			print("Config file successfully deleted.")
		else:
			print("Failed to delete config file.")

func load_config():
	
	library_root = ""
	
	var config = ConfigFile.new()
	
	# Load data from a file.
	var err = config.load(SETTINGS_FILE)

	# If the file didn't load, ignore it.
	if err != OK:
		print("No config file found, starting fresh.")
		return
	
	# Get the root dir
	var saved_root = config.get_value(APP_SECTION, LIBRARY_ROOT)
	if saved_root != null:
		library_root = saved_root
		print("Loaded root: %s", saved_root)

func _ready():
	if DEBUG_RESET_CONFIG:
		delete_config()
	load_config()
