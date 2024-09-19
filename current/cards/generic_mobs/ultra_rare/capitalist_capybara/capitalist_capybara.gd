extends Card

#region Card stats
@export var card_title: String = "Cappy"
@export var card_flavor_text: String = "A weird capybara thing"

@export var card_health: float = 75.0 #Health amount of card
@export var card_phys_attack: int = 12 #physical Attack value of the card
@export var card_mag_attack: int = 8 #Magic attack value of the card
@export var card_phys_defense: int = 10 #Physical defense of the card
@export var card_mag_defense: int = 8 #Magical defense of the card
@export var card_speed: int = 6 #Speed of the card
@export var card_tags: Array[String] = ["cute_animal", "animal", "capitalist", "streamer"]

#Modifiers for shifting, are added or subtracted from the normal stats when shifting
@export var card_shifted_health: float = 0.0
@export var card_shifted_phys_attack: int = 1
@export var card_shifted_mag_attack: int = 1
@export var card_shifted_phys_defense: int = 1
@export var card_shifted_mag_defense: int = 1
@export var card_shifted_speed: int = -2
@export var card_shifted_tags: Array[String] = ["detective"]

#Stats changed for being in the prefered positions
@export var card_pos_health: float = 0.0
@export var card_pos_phys_attack: int = 2
@export var card_pos_mag_attack: int = 2
@export var card_pos_phys_defense: int = -1
@export var card_pos_mag_defense: int = -1
@export var card_pos_speed: int = 3
@export var card_pos_tags: Array[String] = ["on_time"]

#Position stats/effects should only be applied when the play button is pressed!
@export var card_pref_pos: Array[String] = ["center"] #Prefered possitions of the car

@export var card_default_color: Color = modulate #for default color
@export var card_default_size: Vector2 = Vector2(1,1) #Default size for the ca

@export var card_shifted: bool = false
@export var card_friendly: bool = true
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
func default_action() -> void:
	var enemy = get_target()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,5)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Capytax!\" \n"
			CombatLib.mag_life_steal_lesser(self, enemy, damage+mag_attack-2)
		2:
			Combat.combat_board = Combat.combat_board + "\"Investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack-5)
		3:
			CombatLib.phys_attack(self, enemy, damage+phys_attack)
		4: 
			Combat.combat_board = Combat.combat_board + "\"Collab time!\"\n"
			CombatLib.baton_pass(self, get_ally())
		5:
			Combat.combat_board = Combat.combat_board + "\"Cappy is distracted!\"\n"
			CombatLib.self_heal(self, 1+damage+mag_attack/3.0)

#Should normally be called when standing in the front
func front_action() -> void:
	var enemy = get_target()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,7)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Capytax!\" \n"
			CombatLib.mag_life_steal_lesser(self, enemy, damage+mag_attack-2)
		2,3:
			Combat.combat_board = Combat.combat_board + "\"Investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack-5)
		4,5:
			CombatLib.phys_attack(self, enemy, damage+phys_attack)
		6: 
			Combat.combat_board = Combat.combat_board + "\"Collab time!\"\n"
			CombatLib.baton_pass(self, get_ally())
		7:
			Combat.combat_board = Combat.combat_board + "\"Cappy is distracted!\"\n"
			CombatLib.self_heal(self, 1+damage+mag_attack/3.0)

#Should normally be called when standing in the center
func center_action() -> void:
	var enemy = get_target()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,7)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Capytax!\" \n"
			CombatLib.mag_life_steal_lesser(self, enemy, damage+mag_attack-2)
		2,3,4:
			Combat.combat_board = Combat.combat_board + "\"Investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack-5)
		5:
			CombatLib.phys_attack(self, enemy, damage+phys_attack)
		6: 
			Combat.combat_board = Combat.combat_board + "\"Collab time!\"\n"
			CombatLib.baton_pass(self, get_ally())
		7:
			Combat.combat_board = Combat.combat_board + "\"Cappy is distracted!\"\n"
			CombatLib.self_heal(self, 1+damage+mag_attack/3.0)

#Should normally be called when standing in the center
func back_action() -> void:
	var enemy = get_target()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,7)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Capytax!\" \n"
			CombatLib.mag_life_steal_lesser(self, enemy, damage+mag_attack-2)
		2:
			Combat.combat_board = Combat.combat_board + "\"Investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack-5)
		3:
			CombatLib.phys_attack(self, enemy, damage+phys_attack)
		4: 
			Combat.combat_board = Combat.combat_board + "\"Collab time!\"\n"
			CombatLib.baton_pass(self, get_ally())
		5,6,7:
			Combat.combat_board = Combat.combat_board + "\"Cappy is distracted!\"\n"
			CombatLib.self_heal(self, 1+damage+mag_attack/3.0)

#Should normally never be called as long as the card is in a slot
func shifted_default_action() -> void:
	var enemy = get_target()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,7)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Capytax!\" \n"
			CombatLib.life_steal_lesser(self, enemy, damage+mag_attack)
		2,3:
			Combat.combat_board = Combat.combat_board + "\"Investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack-3)
		4:
			CombatLib.phys_attack(self, enemy, damage+phys_attack)
		5: 
			Combat.combat_board = Combat.combat_board + "\"Collab time!\"\n"
			CombatLib.baton_pass(self, get_ally())
		6:
			Combat.combat_board = Combat.combat_board + "\"Cappy is distracted!\"\n"
			CombatLib.self_heal(self, 1+damage+mag_attack/3.0)
		7:
			Combat.combat_board = Combat.combat_board + "\"CRIT investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack)

#Should normally be called when standing in the front
func shifted_front_action() -> void:
	var enemy = get_target()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,7)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Capytax!\" \n"
			CombatLib.life_steal_lesser(self, enemy, damage+mag_attack)
		2:
			Combat.combat_board = Combat.combat_board + "\"Investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack-3)
		3,4:
			CombatLib.phys_attack(self, enemy, damage+phys_attack)
		5: 
			Combat.combat_board = Combat.combat_board + "\"Collab time!\"\n"
			CombatLib.baton_pass(self, get_ally())

		6:
			Combat.combat_board = Combat.combat_board + "\"Cappy is distracted!\"\n"
			CombatLib.self_heal(self, 1+damage+mag_attack/3.0)
		7:
			Combat.combat_board = Combat.combat_board + "\"CRIT investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack)

#Should normally be called when standing in the center
func shifted_center_action() -> void:
	var enemy = get_target()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,7)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Capytax!\" \n"
			CombatLib.life_steal_lesser(self, enemy, damage+mag_attack)
		2:
			Combat.combat_board = Combat.combat_board + "\"Investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack-3)
		3:
			CombatLib.phys_attack(self, enemy, damage+phys_attack)
		4: 
			Combat.combat_board = Combat.combat_board + "\"Collab time!\"\n"
			CombatLib.baton_pass(self, get_ally())
		5:
			Combat.combat_board = Combat.combat_board + "\"Cappy is distracted!\"\n"
			CombatLib.self_heal(self, 1+damage+mag_attack/3.0)
		6,7:
			Combat.combat_board = Combat.combat_board + "\"CRIT investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack)


#Should normally be called when standing in the center
func shifted_back_action() -> void:
	var enemy = get_target()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,7)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Capytax!\" \n"
			CombatLib.life_steal_lesser(self, enemy, damage+mag_attack)
		2:
			Combat.combat_board = Combat.combat_board + "\"Investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack-3)
		3:
			CombatLib.phys_attack(self, enemy, damage+phys_attack)
		4: 
			Combat.combat_board = Combat.combat_board + "\"Collab time!\"\n"
			CombatLib.baton_pass(self, get_ally())
		5,6:
			Combat.combat_board = Combat.combat_board + "\"Cappy is distracted!\"\n"
			CombatLib.self_heal(self, 1+damage+mag_attack/3.0)
		7:
			Combat.combat_board = Combat.combat_board + "\"CRIT investigation!\"\n"
			CombatLib.lock_down(self, enemy)
			CombatLib.mag_attack(self, enemy, damage+phys_attack)
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
