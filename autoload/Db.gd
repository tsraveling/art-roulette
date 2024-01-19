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

func create_folder(name, path):
	var find_query = """
		SELECT id FROM folders WHERE path = ?;
	"""
	var result = db.query_with_bindings(find_query, [path])
	if result.empty():
		var insert_query = """
			INSERT INTO folders (name, parent_id, path)
			VALUES (?, ?, ?);
		"""
		db.query_with_bindings(insert_query, [name, null, path])  # Assuming parent_id is null for simplicity
		result = db.query_with_bindings(find_query, [path])  # Re-query to get the newly inserted ID

	# STUB: query just returns a boolean. We have to use select or something. Do this next
	return 0 #result[0]["id"]  # Returning the ID



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
