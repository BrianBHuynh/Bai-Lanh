extends Node

var ally_list: Array[String] = ["res://current/cards/named_chars/ultra_rare/lost_herbalist/lost_herbalist.gd", "res://current/cards/named_chars/ultra_rare/capitalist_capybara/capitalist_capybara.gd", "res://current/cards/generic_mobs/uncommon/turtle_dog/turtle_dog.gd", "res://current/cards/generic_mobs/rare/blind_assassin_worm/blind_assassin_worm.gd", "res://current/cards/generic_mobs/common/archer/archer.gd"]
var enemy_list: Array[String] = ["res://current/cards/named_chars/ultra_rare/lost_herbalist/lost_herbalist.gd", "res://current/cards/named_chars/ultra_rare/capitalist_capybara/capitalist_capybara.gd", "res://current/cards/generic_mobs/uncommon/turtle_dog/turtle_dog.gd", "res://current/cards/generic_mobs/rare/blind_assassin_worm/blind_assassin_worm.gd", "res://current/cards/generic_mobs/common/archer/archer.gd"]

func get_card(card_link: String):
	var card = load("res://current/scenes/card/card.tscn").instantiate()
	card.set_script(load(card_link))
	card.initialize()
	card.update_image()
	return card

func get_card_script(card_script: Script):
	var card = load("res://current/scenes/card/card.tscn").instantiate()
	card.set_script(card_script)
	card.initialize()
	card.update_image()
	return card
