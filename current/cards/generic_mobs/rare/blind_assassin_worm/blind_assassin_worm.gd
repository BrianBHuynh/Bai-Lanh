extends Card

#region Card stats
@export var card_title: String = "Blind Assassin Worm"
@export var card_flavor_text: String = "He sacrificed his eyesight for power but was betrayed in the end"

@export var card_health: float = 35.0 #Health amount of card
@export var card_phys_attack: int = 8 #physical Attack value of the card
@export var card_mag_attack: int = 12 #Magic attack value of the card
@export var card_phys_defense: int = 8 #Physical defense of the card
@export var card_mag_defense: int = 8 #Magical defense of the card
@export var card_speed: int = 4 #Speed of the card
@export var card_tags: Array[String] = ["assasin", "blind", "summoner", "shadow"]

#Modifiers for shifting, are added or subtracted from the normal stats when shifting
@export var card_shifted_health: float = -25.0
@export var card_shifted_phys_attack: int = 2
@export var card_shifted_mag_attack: int = 2
@export var card_shifted_phys_defense: int = -2
@export var card_shifted_mag_defense: int = -2
@export var card_shifted_speed: int = 2
@export var card_shifted_tags: Array[String] = ["undead"]

#Stats changed for being in the prefered positions
@export var card_pos_health: float = -10.0
@export var card_pos_phys_attack: int = 1
@export var card_pos_mag_attack: int = 1
@export var card_pos_phys_defense: int = -1
@export var card_pos_mag_defense: int = -1
@export var card_pos_speed: int = 2
@export var card_pos_tags: Array[String] = ["combo"]

#Position stats/effects should only be applied when the play button is pressed!
@export var card_pref_pos: Array[String] = ["back"] #Prefered possitions of the card

@export var card_default_color: Color = modulate #for default color
@export var card_default_size: Vector2 = Vector2(1,1) #Default size for the card

@export var card_shifted: bool = false
@export var card_friendly: bool = true

var summon = load("res://current/cards/generic_mobs/rare/blind_assassin_worm/mysterious_shadow_worm/evil_shadow_worm.tscn")

#endregion

#region Card initialization
func _ready() -> void:
	title = card_title
	flavor_text = card_flavor_text
	health = card_health
	phys_attack = card_phys_attack
	mag_attack = card_mag_attack
	phys_defense = card_phys_defense
	mag_defense = card_mag_attack
	speed = card_speed
	tags = card_tags
	shifted_health = card_shifted_health
	shifted_phys_attack = card_shifted_phys_attack
	shifted_mag_attack = card_shifted_mag_attack
	shifted_phys_defense = card_shifted_phys_defense
	shifted_mag_defense = card_shifted_mag_attack
	shifted_speed = card_shifted_speed
	shifted_tags = card_shifted_tags
	pos_health = card_pos_health
	pos_phys_attack = card_pos_phys_attack
	pos_mag_attack = card_pos_mag_attack
	pos_phys_defense = card_pos_phys_defense
	pos_mag_defense = card_pos_mag_attack
	pos_speed = card_pos_speed
	pos_tags = card_pos_tags
	pref_pos = card_pref_pos
	default_color = card_default_color
	default_size = card_default_size
	if card_shifted:
		shift()
	friendly = card_friendly
	initialize()
#endregion

#region Actions
func summon_shade() -> void:
	var instance = summon.instantiate()
	get_parent().add_child(instance)
	instance.friendly = false
	instance.new_slot = slot
	if friendly:
		Cards.place_slot_player(instance)
	else:
		Cards.place_slot_opposing(instance)
	Combat.add_initiative(instance)

func default_action() -> void:
	var enemy = get_target()
	var ally = get_ally()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,7)
	match ability:
		1,2:
			CombatLib.multi_phys_attack(self, enemy, 5, 4)
		3:
			CombatLib.phys_attack(self, enemy, damage-2)
		4:
			CombatLib.phys_attack(self, enemy, damage-3)
		5: 
			CombatLib.phys_attack(self, enemy, damage-5)
		6,7:
			if slot.cards_list.size() > 1:
				CombatLib.baton_pass(self, slot.cards_list[1])
				CombatLib.phys_attack(self, enemy, damage-2)
			else:
				summon_shade()

#Should normally be called when standing in the front
#func front_action() -> void:
#	default_action()

#Should normally be called when standing in the center
#func center_action() -> void:
#	default_action()

#Should normally be called when standing in the center
func back_action() -> void:
	var enemy = get_target()
	var ally = get_ally()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,8)
	match ability:
		1,2:
			CombatLib.multi_phys_attack(self, enemy, 5, 4)
		3:
			CombatLib.phys_attack(self, enemy, damage-2)
		4:
			CombatLib.phys_attack(self, enemy, damage-3)
		5: 
			CombatLib.phys_attack(self, enemy, damage-5)
		6,7,8:
			if slot.cards_list.size() > 1:
				CombatLib.baton_pass(self, slot.cards_list[1])
				CombatLib.phys_attack(self, enemy, damage-2)
			else:
				summon_shade()

#Should normally never be called as long as the card is in a slot
#func shifted_default_action() -> void:
#	default_action()

#Should normally be called when standing in the front
#func shifted_front_action() -> void:
#	shifted_default_action()

#Should normally be called when standing in the center
#func shifted_center_action() -> void:
#	shifted_default_action()

#Should normally be called when standing in the center
func shifted_back_action() -> void:
	var enemy = get_target()
	var ally = get_ally()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,8)
	match ability:
		1,2:
			CombatLib.multi_phys_attack(self, enemy, 5, 4)
		3:
			CombatLib.phys_attack(self, enemy, damage-2)
		4:
			CombatLib.phys_attack(self, enemy, damage-3)
		5: 
			CombatLib.phys_attack(self, enemy, damage-5)
		6,7,8:
			if slot.cards_list.size() > 1:
				CombatLib.baton_pass(self, slot.cards_list[1])
				CombatLib.phys_attack(self, enemy, damage-2)
			else:
				summon_shade()
#endregion

#region Targeting
#func get_target() -> void:
#	if friendly:
#		if not shifted:
#			if pos == "front":
#				return Combat.get_target(Combat.opposing_party)
#			elif pos == "center":
#				return Combat.get_target(Combat.opposing_party)
#			elif pos == "back":
#				return Combat.get_target(Combat.opposing_party)
#			else:
#				return Combat.get_target(Combat.opposing_party)
#		else:
#			if pos == "front":
#				return Combat.get_target(Combat.opposing_party)
#			elif pos == "center":
#				return Combat.get_target(Combat.opposing_party)
#			elif pos == "back":
#				return Combat.get_target(Combat.opposing_party)
#			else:
#				return Combat.get_target(Combat.opposing_party)
#	else:
#		if not shifted:
#			if pos == "front":
#				return Combat.get_target(Combat.player_party)
#			elif pos == "center":
#				return Combat.get_target(Combat.player_party)
#			elif pos == "back":
#				return Combat.get_target(Combat.player_party)
#			else:
#				return Combat.get_target(Combat.player_party)
#		else:
#			if pos == "front":
#				return Combat.get_target(Combat.player_party)
#			elif pos == "center":
#			elif pos == "back":
#				return Combat.get_target(Combat.player_party)
#			else:
#				return Combat.get_target(Combat.player_party)

#func get_ally() -> Card:
	#if friendly:
		#if not shifted:
			#if pos == "front":
				#return Combat.get_target(Combat.player_party)
			#elif pos == "center":
				#return Combat.get_target(Combat.player_party)
			#elif pos == "back":
				#return Combat.get_target(Combat.player_party)
			#else:
				#return Combat.get_target(Combat.player_party)
		#else:
			#if pos == "front":
				#return Combat.get_target(Combat.player_party)
			#elif pos == "center":
				#return Combat.get_target(Combat.player_party)
			#elif pos == "back":
				#return Combat.get_target(Combat.player_party)
			#else:
				#return Combat.get_target(Combat.player_party)
	#else:
		#if not shifted:
			#if pos == "front":
				#return Combat.get_target(Combat.opposing_party)
			#elif pos == "center":
				#return Combat.get_target(Combat.opposing_party)
			#elif pos == "back":
				#return Combat.get_target(Combat.opposing_party)
			#else:
				#return Combat.get_target(Combat.opposing_party)
		#else:
			#if pos == "front":
				#return Combat.get_target(Combat.opposing_party)
			#elif pos == "center":
				#return Combat.get_target(Combat.opposing_party)
			#elif pos == "back":
				#return Combat.get_target(Combat.opposing_party)
			#else:
				#return Combat.get_target(Combat.opposing_party)
#endregion

#region Combat
func damage_physical(damage: int) -> int:
	if slot.cards_list.size() > 1:
		return slot.cards_list[slot.cards_list.size()-1].damage_physical(damage)
	else:
		var change = damage - phys_defense
		if change > 0:
			health = health-change
		else:
			health = health - 1
			change = 1
		check_death()
		return change

func damage_magical(damage: int) -> int:
	if slot.cards_list.size() > 1:
		return slot.cards_list[slot.cards_list.size()-1].damage_magical(damage)
	else:
		var change = damage - mag_defense
		if change > 0:
			health = health-change
		else:
			health = health - 1
			change = 1
		check_death()
		return change
#endregion
