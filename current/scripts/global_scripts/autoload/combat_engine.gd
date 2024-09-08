extends Node2D

#All slots are initialized here at the start of the scene
var slots = [] 

#Players and Opposing parties
var player_party: Array = []
var opposing_party: Array = []

#Player positions
var player_front: Array = []
var player_mid: Array = []
var player_back: Array = []
#Player roles
var player_tanks: Array = []
var player_dps: Array = []
var player_support: Array = []

#Opponent positions
var opposing_front: Array = []
var opposing_mid: Array = []
var opposing_back: Array = []

#Opponent roles
var opposing_tanks: Array = []
var opposing_dps: Array = []
var opposing_support: Array = []

#Turn order
var initiative: Array = []

#Used for complex agro calculation
var agro_calc: Array = []

#RNG is pain
var RNG = RandomNumberGenerator.new()

var combat_board = ""
var arrays: Array = [slots, player_party, opposing_party, player_front, player_mid, player_back, player_tanks, player_dps, player_support, opposing_front, opposing_mid, opposing_back, opposing_tanks, opposing_dps, opposing_support, initiative, agro_calc]
#returns next in initiative, if initiative is empty repopulates it
func get_initiative():
	if initiative.is_empty():
		recalc_initiative()
	return initiative.pop_front()

func get_target(array):
	agro_calc.clear()
	agro_calc.append_array(array)
	agro_calc.shuffle()
	return agro_calc.pop_front()

#Assumes both parties are alive and appends both to initiative, then shuffles. Multiplies occurance of each character by the amount of speed they have
func recalc_initiative():
	for i in player_party.size():
		for j in player_party[i].speed:
			initiative.append(player_party[i])
	for i in opposing_party.size():
		for j in opposing_party[i].speed:
			initiative.append(opposing_party[i])
	initiative.shuffle()

func add_initiative(card):
	for i in card.speed:
		initiative.append(card)
		initiative.shuffle()

func next_turn():
	var curChar = get_initiative()
	if is_instance_valid(curChar):
		combat_board = ""
		if not opposing_party.is_empty() and not player_party.is_empty():
			curChar.action()

#Applies slot stats and effects
func slot_apply(card):
	card.health = card.health + card.cur_slot.slot_health
	card.attack = card.attack + card.cur_slot.slot_attack
	card.defense = card.defense + card.cur_slot.slot_defense
	card.speed = card.speed + card.cur_slot.slot_speed
	card.cur_slot.activate()

func pos_apply(card):
	if card.pref_pos.has(card.cur_slot.pos):
		card.health = card.health + card.pos_health
		card.attack = card.attack + card.pos_attack
		card.defense = card.defense + card.pos_defense
		card.speed = card.speed + card.pos_speed
		card.posEffect(card.cur_slot.pos)

func kill(card):
	if is_instance_valid(card):
		for array in arrays:
			while array.has(card):
				array.erase(card)
		for slot in slots:
			while slot.cards_list.has(card):
				slot.cards_list.erase(card)
		await get_tree().create_timer(.125).timeout
		card.queue_free()

func clear_data():
	for array in arrays:
		array.clear()
	await get_tree().create_timer(.125).timeout
