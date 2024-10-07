extends Card

#region Card stats
@export var card_title: String = "Archer"
@export var card_flavor_text: String = "Shoots on the same row (most of the time)"

@export var card_health: float = 75.0 #Health amount of card
@export var card_phys_attack: float = 12 #physical Attack value of the card
@export var card_mag_attack: float = 8 #Magic attack value of the card
@export var card_phys_defense: float = 8 #Physical defense of the card
@export var card_mag_defense: float = 8 #Magical defense of the card
@export var card_speed: int = 9 #Speed of the card
@export var card_tags: Array[String] = ["ranged", "generic"]

#Modifiers for shifting, are added or subtracted from the normal stats when shifting
@export var card_shifted_health: float = 0.0
@export var card_shifted_phys_attack: float = -2
@export var card_shifted_mag_attack: float = 2
@export var card_shifted_phys_defense: float = 2
@export var card_shifted_mag_defense: float = 2
@export var card_shifted_speed: int = 1
@export var card_shifted_tags: Array[String] = ["balanced"]

#Stats changed for being in the prefered positions
@export var card_pos_health: float = -10.0
@export var card_pos_phys_attack: float = 2
@export var card_pos_mag_attack: float = 2
@export var card_pos_phys_defense: float = 0
@export var card_pos_mag_defense: float = 0
@export var card_pos_speed: int = 2
@export var card_pos_tags: Array[String] = ["rapid fire"]

#Position stats/effects should only be applied when the play button is pressed!
@export var card_pref_pos: Array[String] = ["back"] #Prefered possitions of the card

@export var card_default_color: Color = modulate #for default color
@export var card_default_size: Vector2 = Vector2(1,1) #Default size for the card

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
	var _ally = get_ally()
	var damage = (Combat.RNG.randi_range(1,10))
	var ability = Combat.RNG.randi_range(1,2)
	match ability:
		1:
			CombatLib.phys_attack(self, enemy, damage)
		2:
			CombatLib.mag_attack(self, enemy, damage)

#Should normally be called when standing in the front
#func front_action() -> void:
#	default_action()

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
#func shifted_front_action() -> void:
#	shifted_default_action()

#Should normally be called when standing in the center
#func shifted_center_action() -> void:
#	shifted_default_action()

#Should normally be called when standing in the center
#func shifted_back_action() -> void:
#	shifted_default_action()
#endregion

#region Targeting
#region Simple
func get_target() -> Card:
	return Targeting.simple_targeting(self, "same_pos")
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
