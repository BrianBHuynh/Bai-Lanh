extends Node

func _ready() -> void:
	if not DirAccess.dir_exists_absolute("user://saves"):
		DirAccess.make_dir_absolute("user://saves")
	if not DirAccess.dir_exists_absolute("user://backup"):
		DirAccess.make_dir_absolute("user://backup")
	if not DirAccess.dir_exists_absolute("user://fallback"):
		DirAccess.make_dir_absolute("user://fallback")

func save_file(content, location: String):
	var content_json = JSON.stringify(content)
	OpenWrite("user://saves/" + location + ".lanhPACK").store_var(content_json, false)
	OpenWrite("user://saves/" + location + ".lanhCERT").store_var(FileAccess.get_sha256("user://saves/" + location + ".lanhPACK"), false)
	OpenWrite("user://backup/" + location + ".lanhPACK").store_var(content_json, false)
	OpenWrite("user://backup/" + location + ".lanhCERT").store_var(FileAccess.get_sha256("user://backup/" + location + ".lanhPACK"), false)
	OpenWrite("user://fallback/" + location + ".lanhPACK").store_var(content_json, false)
	OpenWrite("user://fallback/" + location + ".lanhCERT").store_var(FileAccess.get_sha256("user://fallback/" + location + ".lanhPACK"), false)

func load_file(location):
	var content = JSON.new()
	if FileAccess.file_exists("user://saves/" + location + ".lanhPACK") and FileAccess.get_sha256("user://saves/" + location + ".lanhPACK") == FileAccess.open_encrypted_with_pass("user://saves/" + location + ".lanhCERT", FileAccess.READ, OS.get_unique_id()).get_var() and content.parse(FileAccess.open_encrypted_with_pass("user://saves/" + location + ".lanhPACK", FileAccess.READ, OS.get_unique_id()).get_var(false), false) == OK:
		print("File 1 passed all checks")
		return content.data
	elif FileAccess.file_exists("user://backup/" + location + ".lanhPACK") and FileAccess.get_sha256("user://backup/" + location + ".lanhPACK") == FileAccess.open_encrypted_with_pass("user://backup/" + location + ".lanhCERT", FileAccess.READ, OS.get_unique_id()).get_var() and content.parse(FileAccess.open_encrypted_with_pass("user://backup/" + location + ".lanhPACK", FileAccess.READ, OS.get_unique_id()).get_var(false), false) == OK:
		print("File 1 has failed it's checks, file 2 passed all checks")
		return content.data
	elif FileAccess.file_exists("user://fallback/" + location + ".lanhPACK") and FileAccess.get_sha256("user://fallback/" + location + ".lanhPACK") == FileAccess.open_encrypted_with_pass("user://fallback/" + location + ".lanhCERT", FileAccess.READ, OS.get_unique_id()).get_var() and content.parse(FileAccess.open_encrypted_with_pass("user://fallback/" + location + ".lanhPACK", FileAccess.READ, OS.get_unique_id()).get_var(false), false) == OK:
		print("File 1 and 2 have failed their checks, file 3 passed all checks")
		return content.data
	else:
		push_warning("File damaged beyond repair!")
		return null

func save_game():
	pass

func OpenWrite(path: String) -> FileAccess:
	return FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, OS.get_unique_id())

func OpenRead(path: String) -> FileAccess:
	return FileAccess.open_encrypted_with_pass(path, FileAccess.READ, OS.get_unique_id())
