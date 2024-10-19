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
	OpenWrite("user://saves/" + location + ".lanhfile").store_var(content_json, false)
	OpenWrite("user://saves/" + location + ".checksum").store_var(FileAccess.get_sha256("user://saves/" + location + ".lanhshard"), false)
	OpenWrite("user://backup/" + location + ".lanhshard").store_var(content_json, false)
	OpenWrite("user://backup/" + location + ".checksum").store_var(FileAccess.get_sha256("user://backup/" + location + ".lanhshard"), false)
	OpenWrite("user://fallback/" + location + ".lanhshard").store_var(content_json, false)
	OpenWrite("user://fallback/" + location + ".checksum").store_var(FileAccess.get_sha256("user://fallback/" + location + ".lanhshard"), false)

func load_file(location):
	var file = FileAccess.open_encrypted_with_pass("user://saves/" + location + ".lanhshard", FileAccess.READ, OS.get_unique_id())
	print("test here")
	print(FileAccess.get_sha256("user://saves/" + location + ".lanhshard"))
	print(FileAccess.open_encrypted_with_pass("user://saves/" + location + ".checksum", FileAccess.READ, OS.get_unique_id()).get_var())
	if is_instance_valid(file) and FileAccess.get_sha256("user://saves/" + location + ".lanhshard") == FileAccess.open_encrypted_with_pass("user://saves/" + location + ".checksum", FileAccess.READ, OS.get_unique_id()).get_var():
		print("Checksum 1 passed")
		var content = JSON.new()
		content.parse(file.get_var(true), false)
		return content.data

func save_game():
	pass

func OpenWrite(path: String) -> FileAccess:
	return FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, OS.get_unique_id())

func OpenRead(path: String) -> FileAccess:
	return FileAccess.open_encrypted_with_pass(path, FileAccess.READ, OS.get_unique_id())
