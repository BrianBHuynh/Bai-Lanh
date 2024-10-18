extends Node

func save_file(content, location: String):
	var file = FileAccess.open_encrypted_with_pass("user://" + location + ".lanh_shard", FileAccess.WRITE, GlobalVars.player_name)
	var content_json = JSON.stringify(content)
	file.store_var(content_json, true)

func load_file(location):
	var file = FileAccess.open_encrypted_with_pass("user://" + location + ".lanh_shard", FileAccess.READ, GlobalVars.player_name)
	if is_instance_valid(file):
		var content: Dictionary = JSON.parse_string(file.get_var(true))
		return content

func save_game():
	pass
