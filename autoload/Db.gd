extends Node

const DEBUG_CLEAR_ON_START := true

var db: SQLite

func initialize_in_root(library_path):
	
	# Initialize the SQLite database
	db = SQLite.new()
	db.path = library_path
	db.foreign_keys = true
	db.open_db()
	
	# Create the database
	db.query(CreateQueries.CREATE_FOLDERS)
	db.query(CreateQueries.CREATE_IMAGES)
	db.query(CreateQueries.CREATE_TAGS)
	db.query(CreateQueries.CREATE_IMAGE_TAGS)
	db.query(CreateQueries.CREATE_MIGRATIONS)
	
	if DEBUG_CLEAR_ON_START:
		print(">>> deleting previous ...")
		db.query("DELETE FROM folders")
		db.query("DELETE FROM images")
	
	db.close_db()

func create_images(row_list):
	db.insert_rows("images", row_list)

func get_image_list(folder_id) -> Array[String]:
	var conditional = ("folder_id='%s'" % str(folder_id)) if folder_id != null else "folder_id IS NULL"
	var images = db.select_rows("images", conditional, ["title"])
	var ret: Array[String] = []
	for img in images:
		ret.append(img["title"])
	return ret

func create_folder(folder_name, parent_id, path):
	var result = db.select_rows("folders", "path='%s'" % path, ["id"])
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
