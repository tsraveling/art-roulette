extends Object
class_name CreateQueries

const CREATE_FOLDERS = """
	CREATE TABLE IF NOT EXISTS folders (
		id INTEGER PRIMARY KEY,
		name TEXT,
		parent_id INTEGER,
		path TEXT unique
	)
"""

const CREATE_TAGS = """
	CREATE TABLE IF NOT EXISTS tags (
		id INTEGER PRIMARY KEY,
		name TEXT
	)
"""

const CREATE_IMAGES = """
	CREATE TABLE IF NOT EXISTS images (
		id INTEGER PRIMARY KEY,
		folder_id INTEGER,
		file_path TEXT,
		title TEXT,
		description TEXT,
		FOREIGN KEY(folder_id) REFERENCES folders(id)
	)
"""

const CREATE_IMAGE_TAGS = """
	CREATE TABLE IF NOT EXISTS image_tags (
		image_id INTEGER,
		tag_id INTEGER,
		PRIMARY KEY(image_id, tag_id),
		FOREIGN KEY(image_id) REFERENCES images(id) ON DELETE CASCADE,
		FOREIGN KEY(tag_id) REFERENCES tags(id) ON DELETE CASCADE
	)
"""

const CREATE_MIGRATIONS = """
	CREATE TABLE IF NOT EXISTS migrations (
		id INTEGER PRIMARY KEY,
		succeeded_at DATETIME,
		last_attempted_at DATETIME,
		version_tag TEXT,
		log TEXT
	)
"""
