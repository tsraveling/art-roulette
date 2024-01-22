extends Node

var db: SQLite

func initialize_in_root(library_path):
	
	# Initialize the SQLite database
	db = SQLite.new()
	db.path = library_path
	db.open_db()

	# Create the database
	db.query(CreateQueries.CREATE_FOLDERS)
	db.query(CreateQueries.CREATE_IMAGES)
	db.query(CreateQueries.CREATE_TAGS)
	db.query(CreateQueries.CREATE_IMAGE_TAGS)
	db.query(CreateQueries.CREATE_MIGRATIONS)
	
	db.close_db()

func create_folder(folder_name, parent_id, path):
	var result = db.select_rows("folders", "path='%s'" % path, ["*"])
	if result.is_empty():
		var row_dict = {
			"name": folder_name,
			"path": path
		}
		if parent_id != null:
			row_dict["parent_id"] = parent_id
		db.insert_row("folders", row_dict)
		return db.last_insert_rowid
	else:
		return result[0]["id"]
		
func begin():
	db.open_db()

func end():
	db.close_db()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
