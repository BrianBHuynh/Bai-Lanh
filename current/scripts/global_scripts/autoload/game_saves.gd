extends Node

func save_file(content, location: String):
	var file = FileAccess.open("user://" + location, FileAccess.WRITE)
	file.store_var(content, true)

func load_file(location):
	var file = FileAccess.open("user://" + location, FileAccess.READ)
	if is_instance_valid(file):
		var content = file.get_var(true)
		return content
