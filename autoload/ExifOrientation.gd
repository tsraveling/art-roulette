class_name ExifOrientation

# Reads the EXIF orientation tag from a JPEG file and applies the matching
# transform to an Image. Godot's Image loader ignores EXIF, so camera photos
# that store rotation as metadata show up sideways.

# Returns the EXIF orientation value (1-8), or 1 (normal) if absent/unreadable.
static func read(path: String) -> int:
	var ext = path.get_extension().to_lower()
	if ext != "jpg" and ext != "jpeg":
		return 1

	var f = FileAccess.open(path, FileAccess.READ)
	if f == null:
		return 1
	f.big_endian = true

	# SOI marker
	if f.get_16() != 0xFFD8:
		return 1

	# Walk marker segments looking for APP1 (0xFFE1) holding the Exif block.
	while f.get_position() < f.get_length():
		var marker = f.get_16()
		if (marker & 0xFF00) != 0xFF00:
			break
		var seg_len = f.get_16()
		if seg_len < 2:
			break
		var seg_start = f.get_position()
		if marker == 0xFFE1:
			var result = _parse_app1(f, seg_start, seg_len - 2)
			if result != 0:
				return result
		# Skip to next segment
		f.seek(seg_start + seg_len - 2)
	return 1

# Parses an APP1 segment's TIFF header + IFD0 for the orientation tag (0x0112).
# Returns 0 if not an Exif segment or tag missing.
static func _parse_app1(f: FileAccess, seg_start: int, seg_data_len: int) -> int:
	if seg_data_len < 14:
		return 0
	# "Exif\0\0"
	if f.get_32() != 0x45786966 or f.get_16() != 0x0000:
		return 0

	var tiff_start = f.get_position()
	var byte_order = f.get_16()
	if byte_order == 0x4949:      # "II" little-endian
		f.big_endian = false
	elif byte_order == 0x4D4D:    # "MM" big-endian
		f.big_endian = true
	else:
		return 0

	f.get_16()  # 0x002A magic
	var ifd_offset = f.get_32()
	f.seek(tiff_start + ifd_offset)

	var entry_count = f.get_16()
	for i in entry_count:
		var tag = f.get_16()
		var type = f.get_16()
		f.get_32()  # count (always 1 for orientation)
		if tag == 0x0112 and type == 3:  # SHORT
			var value = f.get_16()
			f.big_endian = true  # restore for caller
			if value >= 1 and value <= 8:
				return value
			return 0
		f.get_32()  # skip value/offset field of this entry
	return 0

# Applies the orientation transform in place.
static func apply(image: Image, orientation: int) -> void:
	match orientation:
		2:
			image.flip_x()
		3:
			image.rotate_180()
		4:
			image.flip_y()
		5:
			image.rotate_90(CLOCKWISE)
			image.flip_x()
		6:
			image.rotate_90(CLOCKWISE)
		7:
			image.rotate_90(COUNTERCLOCKWISE)
			image.flip_x()
		8:
			image.rotate_90(COUNTERCLOCKWISE)

# Convenience: read + apply for the given file.
static func fix(image: Image, path: String) -> void:
	apply(image, read(path))
