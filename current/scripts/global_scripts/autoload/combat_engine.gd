extends Node

var targeting: Targeting = Targeting.new()
#All slots are initialized here at the start of the scene
var slots: Array = [] 

#Players and Opposing parties
var player_party: Array[Card] = []
var opposing_party: Array[Card] = []

#Player positions
var player_front: Array[Card] = []
var player_center: Array[Card] = []
var player_back: Array[Card] = []

#Player roles
var player_tanks: Array[Card] = []
var player_dps: Array[Card] = []
var player_support: Array[Card] = []

#Opponent positions
var opposing_front: Array[Card] = []
var opposing_center: Array[Card] = []
var opposing_back: Array[Card] = []

#Opponent roles
var opposing_tanks: Array[Card] = []
var opposing_dps: Array[Card] = []
var opposing_support: Array[Card] = []

#Turn order
var initiative: Array[Card] = []

#Used for complex agro calculation
var agro_calc: Array[Card] = []

#RNG is pain
var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

var combat_board:String = ""
var arrays: Array[Array] = [slots, player_party, opposing_party, player_front, player_center, player_back, player_tanks, player_dps, player_support, opposing_front, opposing_center, opposing_back, opposing_tanks, opposing_dps, opposing_support, initiative, agro_calc]
var position_arrays: Array[Array] = [player_front, player_center, player_back, opposing_front, opposing_center, opposing_back]

#returns next in initiative, if initiative is empty repopulates it
func get_initiative() -> Card:
	if initiative.is_empty():
		return null
	else:
		var temp = initiative.pick_random()
		if is_instance_valid(temp):
			return temp
		else:
			return null

func target_clear() -> void:
	agro_calc.clear()

func target_add(array: Array[Card]) -> void:
	agro_calc.append_array(array)

func target_get() -> Card:
	return agro_calc.pick_random()

func add_card(card: Card) -> void:
	if card.friendly:
		player_party.append(card)
		match card.pos:
			"front":
				player_front.append(card)
			"center":
				player_center.append(card)
			"back":
				player_back.append(card)
	else:
		opposing_party.append(card)
		match card.pos:
			"front":
				opposing_front.append(card)
			"center":
				opposing_center.append(card)
			"back":
				opposing_back.append(card)

func add_initiative(card: Card) -> void:
	if not initiative.has(card):
		for i in card.speed:
			initiative.append(card)
			initiative.shuffle()

func add_position(card: Card) -> void:
	if card.friendly:
		if card.pos == "front":
			player_front.append(card)
		elif card.pos == "center":
			player_center.append(card)
		elif card.pos == "back":
			player_back.append(card)
	else:
		if card.pos == "front":
			opposing_front.append(card)
		elif card.pos == "center":
			opposing_center.append(card)
		elif card.pos == "back":
			opposing_back.append(card)

func remove_initiative(card: Card) -> void:
	while initiative.has(card):
		initiative.erase(card)

func remove_position(card: Card) -> void:
	for elem in position_arrays:
		while elem.has(card):
			elem.erase(card)

func refresh(card: Card) -> void:
	remove_position(card)
	remove_initiative(card)
	add_position(card)
	add_initiative(card)

func update(card: Card) -> void:
	if initiative.has(card):
		remove_initiative(card)
		add_initiative(card)
		remove_position(card)
		add_position(card)
	else:
		add_initiative(card)
		add_position(card)

func next_turn() -> void:
	target_clear()
	Status.tick()
	var curChar = get_initiative()
	if is_instance_valid(curChar):
		combat_board = ""
		if not opposing_party.is_empty() and not player_party.is_empty():
			curChar.action()

#Applies slot stats and effects
func slot_apply(card) -> void:
	card.health = card.health + card.cur_slot.slot_health
	card.attack = card.attack + card.cur_slot.slot_attack
	card.defense = card.defense + card.cur_slot.slot_defense
	card.speed = card.speed + card.cur_slot.slot_speed
	card.cur_slot.activate()

func pos_apply(card) -> void:
	if card.pref_pos.has(card.cur_slot.pos):
		card.health = card.health + card.pos_health
		card.attack = card.attack + card.pos_attack
		card.defense = card.defense + card.pos_defense
		card.speed = card.speed + card.pos_speed
		card.posEffect(card.cur_slot.pos)

func clear_data() -> void:
	for array in arrays:
		array.clear()
	await get_tree().create_timer(.125).timeout
