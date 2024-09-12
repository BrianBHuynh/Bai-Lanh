extends Node2D
class_name Card

#region Card stats
var title: String = "Card"

var health: float = 100.0 #Health amount of card
var phys_attack: int = 10 #physical Attack value of the card
var mag_attack: int = 10 #Magic attack value of the card
var phys_defense: int = 10 #Physical defense of the card
var mag_defense: int = 10 #Magical defense of the card
var speed: int = 10 #Speed of the card
var tags: Array[String] = []

#Modifiers for shifting, are added or subtracted from the normal stats when shifting
var shifted_health: float = 0.0
var shifted_phys_attack: int = 0
var shifted_mag_attack: int = 0
var shifted_phys_defense: int = 0
var shifted_mag_defense: int = 0
var shifted_speed: int = 0
var shifted_tags: Array[String] = []
#Stats changed for being in the prefered positions
var pos_health: float = 0.0
var pos_phys_attack: int = 0
var pos_mag_attack: int = 0
var pos_phys_defense: int = 0
var pos_mag_defense: int = 0
var pos_speed: int = 0
var pos_tags: Array[String] = []

var status: Array[StatusEffect] = []

#Position stats/effects should only be applied when the play button is pressed!
var pref_pos: Array[String] = [] #Prefered possitions of the card
var pos: String = "None" #Current position

var slot #Where the current slot is stored
var new_slot #Where a possible slot is

var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var current_position #Where the card is currently resting, set at the start to where the card enters the scene tree for the first time

var default_color: Color = modulate #for default color
var default_size: Vector2 = Vector2(1,1) #Default size for the card

var held: bool = false
var inspected: bool = false

var shifted: bool = false
var friendly: bool = true
#endregion

#region Initialization
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize()

func initialize():
	current_position = position
	if friendly == false:
		default_color = Color(Color.PALE_VIOLET_RED)
		modulate = Color(Color.PALE_VIOLET_RED)
		await get_tree().create_timer(.25).timeout
		Combat.opposing_party.append(self)
		Combat.add_initiative(self)
#endregion

#region Input/Signals detection
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if held and friendly:
		hold_card()

func _on_button_down() -> void:
	if Input.is_action_pressed("leftClick"):
		on_card_held()
	else:
		inspect()

func _on_button_up() -> void:
	if Input.is_action_just_released("leftClick"):
		on_card_released()
	else:
		uninspect()

func _on_body_entered(body: Node2D) -> void:
	Cards.add_slot(self, body)


func _on_area_entered(area: Area2D) -> void:
	Cards.add_card(self, area)


func _on_body_exited(body: Node2D) -> void:
	Cards.remove_slot(self, body)


func _on_area_exited(area: Area2D) -> void:
	Cards.remove_card(self, area)

func _on_mouse_entered() -> void:
	highlight()

func _on_mouse_exited() -> void:
	if not inspected:
		normalize()
#endregion

#region Movement and other card functions

func hold_card():
	MoveLib.move_fast(self, get_global_mouse_position() - offset)
	move_to_front()

func on_card_held() -> void:
	if friendly:
		held = true
		offset = get_global_mouse_position() - global_position
		MoveLib.change_scale(self, Vector2(1.5,1.5))


func on_card_released() -> void:
	held = false
	release_card()
	normalize()

func inspect() -> void:
	MoveLib.change_scale(self, Vector2(5,5))
	MoveLib.move_fast(self, get_viewport_rect().size / 2)
	move_to_front()
	inspected = true

func uninspect() -> void:
	reject()
	MoveLib.change_scale(self, default_size)
	inspected = false

func release_card():
	if is_instance_valid(new_slot) and new_slot.accepting and friendly:
		Cards.place_slot_player(self)
		Cards.fix_slot(slot)
	else:
		reject()
		new_slot = null

#returns card back to old position when picking up
func reject():
	if is_instance_valid(slot):
		Cards.fix_slot(slot)
	else:
		MoveLib.move(self, current_position)
func highlight():
	if friendly:
		modulate = Color(Color.PALE_GOLDENROD)
		if Vector2(1.2,1.2) > scale:
			MoveLib.change_scale(self, Vector2(1.2,1.2))
	else:
		modulate = Color(Color.LIGHT_CORAL)
		if Vector2(1.2,1.2) > scale:
			MoveLib.change_scale(self, Vector2(1.2,1.2))

func normalize():
	modulate = default_color
	MoveLib.change_scale(self, default_size)
#endregion

#region Stats update
func shift():
	if not shifted:
		shifted = true
		health = health + shifted_health
		phys_attack = phys_attack + shifted_phys_attack 
		mag_attack = mag_attack + shifted_mag_attack 
		phys_defense = phys_defense + shifted_phys_defense 
		mag_defense = mag_defense + shifted_mag_defense 
		speed = speed + shifted_speed
		tags.append_array(shifted_tags)
	else:
		shifted = false
		health = health - shifted_health
		phys_attack = phys_attack - shifted_phys_attack 
		mag_attack = mag_attack - shifted_mag_attack 
		phys_defense = phys_defense - shifted_phys_defense 
		mag_defense = mag_defense - shifted_mag_defense 
		speed = speed - shifted_speed
		for i in shifted_tags.size():
			tags.erase(shifted_tags[i])
	Combat.update_initiative(self)


func apply_slot_effects():
	health = health + slot.health
	phys_attack = phys_attack + slot.phys_attack 
	mag_attack = mag_attack + slot.mag_attack 
	phys_defense = phys_defense + slot.phys_defense 
	mag_defense = mag_defense + slot.mag_defense 
	speed = speed + slot.speed
	tags.append_array(slot.tags)
	Combat.update_initiative(self)

func remove_slot_effects():
	health = health - slot.health
	phys_attack = phys_attack - slot.phys_attack
	mag_attack = mag_attack - slot.mag_attack 
	phys_defense = phys_defense - slot.phys_defense 
	mag_defense = mag_defense - slot.mag_defense 
	speed = speed - slot.speed
	for i in slot.tags.size():
		tags.erase(slot.tags[i])
	Combat.update_initiative(self)

func pos_apply():
	health = health + pos_health
	phys_attack = phys_attack + pos_phys_attack 
	mag_attack = mag_attack + pos_mag_attack 
	phys_defense = phys_defense + pos_phys_defense 
	mag_defense = mag_defense + pos_mag_defense 
	speed = speed + pos_speed
	tags.append_array(pos_tags)
	Combat.update_initiative(self)

func pos_remove():
	health = health - pos_health
	phys_attack = phys_attack - pos_phys_attack 
	mag_attack = mag_attack - pos_mag_attack 
	phys_defense = phys_defense - pos_phys_defense 
	mag_defense = mag_defense - pos_mag_defense 
	speed = speed - pos_speed
	for i in pos_tags.size():
		tags.erase(pos_tags[i])
	Combat.update_initiative(self)
#endregion

#region Combat
#function is formatted this way so that it is readable and customizable, keeping it in per card allows for more control
func get_target():
	if friendly:
		if not shifted:
			if pos == "front":
				return Combat.get_target(Combat.opposing_party)
			elif pos == "center":
				return Combat.get_target(Combat.opposing_party)
			elif pos == "back":
				return Combat.get_target(Combat.opposing_party)
			else:
				return Combat.get_target(Combat.opposing_party)
		else:
			if pos == "front":
				return Combat.get_target(Combat.opposing_party)
			elif pos == "center":
				return Combat.get_target(Combat.opposing_party)
			elif pos == "back":
				return Combat.get_target(Combat.opposing_party)
			else:
				return Combat.get_target(Combat.opposing_party)
	else:
		if not shifted:
			if pos == "front":
				return Combat.get_target(Combat.player_party)
			elif pos == "center":
				return Combat.get_target(Combat.player_party)
			elif pos == "back":
				return Combat.get_target(Combat.player_party)
			else:
				return Combat.get_target(Combat.player_party)
		else:
			if pos == "front":
				return Combat.get_target(Combat.player_party)
			elif pos == "center":
				return Combat.get_target(Combat.player_party)
			elif pos == "back":
				return Combat.get_target(Combat.player_party)
			else:
				return Combat.get_target(Combat.player_party)

func damage_physical(damage):
	if (damage - phys_defense) > 0:
		health = health-(damage-phys_defense)

func damage_magical(damage):
	if (damage - mag_defense) > 0:
		health = health-(damage-mag_defense)

func damage_true(damage):
	health = health-damage

func action():
	if is_instance_valid(slot):
		slot.action()
	if shifted:
		if pos == "front":
			shifted_front_action()
		elif pos == "center":
			shifted_center_action()
		elif pos == "back":
			shifted_back_action()
		else:
			shifted_default_action()
	else:
		if pos == "front":
			front_action()
		elif pos == "center":
			center_action()
		elif pos == "back":
			back_action()
		else:
			default_action()

func default_action():
	pass

#Should normally be called when standing in the front
func front_action():
	default_action()

#Should normally be called when standing in the center
func center_action():
	default_action()

#Should normally be called when standing in the center
func back_action():
	default_action()

#Should normally never be called as long as the card is in a slot
func shifted_default_action():
	default_action()

#Should normally be called when standing in the front
func shifted_front_action():
	default_action()

#Should normally be called when standing in the center
func shifted_center_action():
	default_action()

#Should normally be called when standing in the center
func shifted_back_action():
	default_action()
#endregion
