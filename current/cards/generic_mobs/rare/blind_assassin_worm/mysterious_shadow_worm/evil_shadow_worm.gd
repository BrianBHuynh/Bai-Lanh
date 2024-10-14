extends Card

#region Card stats
@export var card_title: String = "Evil Shadow Worm"
@export var card_flavor_text: String = "Kinda squishy unless in defensive mode"
@export var card_image_link: String = "res://current/cards/generic_mobs/rare/blind_assassin_worm/mysterious_shadow_worm/evil_shadow_worm.tres"

@export var card_health: float = 5.0 #Health amount of card
@export var card_phys_attack: float = 12 #physical Attack value of the card
@export var card_mag_attack: float = 12 #Magic attack value of the card
@export var card_phys_defense: float = 0 #Physical defense of the card
@export var card_mag_defense: float = 0 #Magical defense of the card
@export var card_speed: int = 5 #Speed of the card
@export var card_tags: Array[String] = ["summon", "shadow", "evil"]

#Modifiers for shifting, are added or subtracted from the normal stats when shifting
@export var card_shifted_health: float = 25.0
@export var card_shifted_phys_attack: float = -4
@export var card_shifted_mag_attack: float = -4
@export var card_shifted_phys_defense: float = 10
@export var card_shifted_mag_defense: float = 10
@export var card_shifted_speed: int = -2
@export var card_shifted_tags: Array[String] = ["tanky"]

#Stats changed for being in the prefered positions
@export var card_pos_health: float = 0.0
@export var card_pos_phys_attack: float = 2
@export var card_pos_mag_attack: float = 2
@export var card_pos_phys_defense: float = 0
@export var card_pos_mag_defense: float = 0
@export var card_pos_speed: int = 2
@export var card_pos_tags: Array[String] = []

#Position stats/effects should only be applied when the play button is pressed!
@export var card_pref_pos: Array[String] = ["front"] #Prefered possitions of the card

@export var card_default_color: Color = modulate #for default color
@export var card_default_size: Vector2 = Vector2(1,1) #Default size for the card

@export var card_shifted: bool = false
@export var card_friendly: bool = true
#endregion

#region Card initialization
func initialize() -> void:
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
	image_link = card_image_link
	if card_shifted:
		shift()
	friendly = card_friendly
	super()
#endregion

#region Actions
func default_action() -> void:
	var enemy = get_target()
	var _ally = get_ally()
	var _damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,4)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Jump!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 8, 2)
			CombatLib.lock_down(self, enemy)
		2:
			Combat.combat_board = Combat.combat_board + "\"Stab!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 5, 2)
			CombatLib.lock_down(self, enemy)
		3:
			Combat.combat_board = Combat.combat_board + "\"Spikes!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 5, 4)
			CombatLib.lock_down(self, enemy)
		4: 
			Combat.combat_board = Combat.combat_board + "\"Defy!\" \n"
			CombatLib.phys_defense_up(self, self)

#Should normally be called when standing in the front
func front_action() -> void:
	var enemy = get_target()
	var _ally = get_ally()
	var _damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,5)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Jump!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 8, 2)
			CombatLib.lock_down(self, enemy)
		2:
			Combat.combat_board = Combat.combat_board + "\"Stab!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 5, 2)
			CombatLib.lock_down(self, enemy)
		3:
			Combat.combat_board = Combat.combat_board + "\"Spikes!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 5, 4)
			CombatLib.lock_down(self, enemy)
		4,5: 
			Combat.combat_board = Combat.combat_board + "\"Defy!\" \n"
			CombatLib.phys_defense_up(self, self)

#Should normally be called when standing in the center
#func center_action() -> void:
#	default_action()

#Should normally be called when standing in the center
#func back_action() -> void:
#	default_action()

#Should normally never be called as long as the card is in a slot
#func shifted_default_action() -> void:
#	default_action()

#Should normally be called when standing in the front
func shifted_front_action() -> void:
	var enemy = get_target()
	var _ally = get_ally()
	var _damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,5)
	match ability:
		1:
			Combat.combat_board = Combat.combat_board + "\"Jump!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 8, 2)
			CombatLib.lock_down(self, enemy)
		2:
			Combat.combat_board = Combat.combat_board + "\"Stab!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 5, 2)
			CombatLib.lock_down(self, enemy)
		3:
			Combat.combat_board = Combat.combat_board + "\"Spikes!\" \n"
			CombatLib.multi_phys_attack(self, enemy, 5, 4)
			CombatLib.lock_down(self, enemy)
		4,5: 
			Combat.combat_board = Combat.combat_board + "\"Defy!\" \n"
			CombatLib.phys_defense_up(self, self)
			CombatLib.baton_pass(self, slot.cards_list[0])

#Should normally be called when standing in the center
#func shifted_center_action() -> void:
#	shifted_default_action()

#Should normally be called when standing in the center
#func shifted_back_action() -> void:
#	shifted_default_action()
#endregion

#region Combat
func damage_physical(damage: float) -> float:
	var change = damage - phys_defense
	if change > 0:
		health = health-change
	else:
		health = health - 1.0
		change = 1.0
	check_death()
	if not slot.cards_list.is_empty():
		slot.cards_list[0].direct_damage_true(1)
	return change

func direct_damage_physical(damage: float) -> float:
	var change = damage - phys_defense
	if change > 0:
		health = health-change
	else:
		health = health - 1.0
		change = 1.0
	check_death()
	if not slot.cards_list.is_empty():
		slot.cards_list[0].direct_damage_true(1)
	return change

func damage_magical(damage: float) -> float:
	var change = damage - mag_defense
	if change > 0:
		health = health-change
	else:
		health = health - 1.0
		change = 1.0
	check_death()
	if not slot.cards_list.is_empty():
		slot.cards_list[0].direct_damage_true(1)
	return change

func direct_damage_magical(damage: float) -> float:
	var change = damage - mag_defense
	if change > 0:
		health = health-change
	else:
		health = health - 1.0
		change = 1.0
	check_death()
	if not slot.cards_list.is_empty():
		slot.cards_list[0].direct_damage_true(1)
	return change
#endregion

#region Targeting
#region Simple
#func get_target() -> Card:
	#return Targeting.simple_targeting(self, "even")
#
#func get_ally() -> Card:
	#return Targeting.simple_ally(self, "even")
#endregion
#region Complex
#func get_target() -> Card:
	#if friendly:
		#if shifted:
			#if pos == "front":
				#return Targeting.even(self, "opposing")
			#elif pos == "center":
				#return Targeting.even(self, "opposing")
			#elif pos == "back":
				#return Targeting.even(self, "opposing")
			#else:
				#return Targeting.even(self, "opposing")
		#else:
			#if pos == "front":
				#return Targeting.even(self, "opposing")
			#elif pos == "center":
				#return Targeting.even(self, "opposing")
			#elif pos == "back":
				#return Targeting.even(self, "opposing")
			#else:
				#return Targeting.even(self, "opposing")
	#else:
		#if shifted:
			#if pos == "front":
				#return Targeting.even(self, "player")
			#elif pos == "center":
				#return Targeting.even(self, "player")
			#elif pos == "back":
				#return Targeting.even(self, "player")
			#else:
				#return Targeting.even(self, "player")
		#else:
			#if pos == "front":
				#return Targeting.even(self, "player")
			#elif pos == "center":
				#return Targeting.even(self, "player")
			#elif pos == "back":
				#return Targeting.even(self, "player")
			#else:
				#return Targeting.even(self, "player")
#
#func get_ally() -> Card:
	#if friendly:
		#if shifted:
			#if pos == "front":
				#return Targeting.even(self, "player")
			#elif pos == "center":
				#return Targeting.even(self, "player")
			#elif pos == "back":
				#return Targeting.even(self, "player")
			#else:
				#return Targeting.even(self, "player")
		#else:
			#if pos == "front":
				#return Targeting.even(self, "player")
			#elif pos == "center":
				#return Targeting.even(self, "player")
			#elif pos == "back":
				#return Targeting.even(self, "player")
			#else:
				#return Targeting.even(self, "player")
	#else:
		#if shifted:
			#if pos == "front":
				#return Targeting.even(self, "opposing")
			#elif pos == "center":
				#return Targeting.even(self, "opposing")
			#elif pos == "back":
				#return Targeting.even(self, "opposing")
			#else:
				#return Targeting.even(self, "opposing")
		#else:
			#if pos == "front":
				#return Targeting.even(self, "opposing")
			#elif pos == "center":
				#return Targeting.even(self, "opposing")
			#elif pos == "back":
				#return Targeting.even(self, "opposing")
			#else:
				#return Targeting.even(self, "opposing")
#endregion
#endregion

func check_death() -> void:
	if health <= 0:
		if not slot.cards_list.is_empty() and not slot.cards_list[0].tags.has("summon"):
			slot.cards_list[0].direct_damage_true(abs(health))
		for status in statuses:
			status.queue_free()
		statuses.clear()
		for array in Combat.arrays:
			while array.has(self):
				array.erase(self)
		for elem in Combat.slots:
			if is_instance_valid(elem):
				while elem.cards_list.has(self):
					elem.cards_list.erase(self)
			else:
				Combat.slots.erase(elem)
		slot.cards_list.erase(self)
		slot.update_accepting()
		await get_tree().create_timer(.125).timeout
		self.queue_free()
