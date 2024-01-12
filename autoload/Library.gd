extends Node

func set_new_root(dir):
	print(">>> set library root: %s" % dir)
	Config.library_root = dir
	Config.save_config()
	# load_library()

func load_library():
	# STUB: create .arlibrary folder in root if needed
	# STUB: Then load it using sqlite
	pass

func _ready():
	if Config.library_root != "":
		print(">>> library root: %s" % Config.library_root)
		print(">>> next step will be to check and initialize that .arlibrary sqlite file there.")
	else:
		# STUB: So show us the different UI instead
		print(">>> no library root found")
