extends Node2D
class_name Card

#region Card stats
var title: String = "Card"
var flavor_text: String

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

var statuses: Array[StatusEffect] = []
var perma_statuses: Array[StatusEffect] = []

#Position stats/effects should only be applied when the play button is pressed!
var pref_pos: Array[String] = [] #Prefered possitions of the card
var pos: String = "None" #Current position

var slot #Where the current slot is stored
var new_slot #Where a possible slot is

var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var current_position: Vector2 #Where the card is currently resting, set at the start to where the card enters the scene tree for the first time
var shadow_scale: Vector2
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

func initialize() -> void:
	current_position = position
	shadow_scale = get_child(0).scale
	set_process(false)
	for i in get_children():
		i.set_process(false)
	if not friendly:
		default_color = Color.PALE_VIOLET_RED
		modulate = Color.PALE_VIOLET_RED
		await get_tree().create_timer(.25).timeout
		shadow_hide()
		Combat.opposing_party.append(self)
		Combat.add_initiative(self)
#endregion

#region Input/Signals detection
# Called every frame. 'delta' is the elapsed time since the previous frame. ONLY activates while the card is being held down.
func _process(_delta: float) -> void:
		hold_card()
		shadow()

func _on_button_down() -> void:
	if Input.is_action_pressed("leftClick") and friendly and not inspected:
		held = true
		on_card_held()
		for i in get_children():
			i.show()
			i.set_process(true)
	else:
		inspect()

func _on_button_up() -> void:
	if Input.is_action_just_released("leftClick") and friendly and not inspected:
		held = false
		on_card_released()
		shadow_hide()
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
	if not inspected and not held:
		normalize()

func _screen_entered() -> void:
	for i in get_children():
		i.show()
		i.set_process(true)

func _screen_exited() -> void:
	for i in get_children():
		i.set_process(false)
		if i != get_child(get_child_count()-1):
			i.hide()
#endregion

#region Movement and other card functions

func hold_card() -> void:
	MoveLib.move_fast(self, get_global_mouse_position() - offset)
	move_to_front()

func on_card_held() -> void:
	if friendly:
		offset = get_global_mouse_position() - global_position
		MoveLib.change_scale(self, Vector2(1.5,1.5))
		set_process(true)


func on_card_released() -> void:
	release_card()
	normalize()
	set_process(false)

func inspect() -> void:
	inspected = true
	MoveLib.change_scale(self, Vector2(5,5))
	MoveLib.move_fast(self, get_viewport_rect().size / 2)
	move_to_front()

func uninspect() -> void:
	reject()
	inspected = false
	MoveLib.change_scale(self, default_size)

func release_card() -> void:
	if is_instance_valid(new_slot) and new_slot.accepting and friendly:
		Cards.place_slot_player(self)
		slot.fix_slot()
	else:
		reject()
		new_slot = null

#returns card back to old position when picking up
func reject() -> void:
	if is_instance_valid(slot):
		slot.fix_slot()
	else:
		MoveLib.move(self, current_position)

func highlight() -> void:
	if friendly:
		modulate = Color.PALE_GOLDENROD
		if Vector2(1.2,1.2) > scale:
			MoveLib.change_scale(self, Vector2(1.2,1.2))
	else:
		modulate = Color.LIGHT_CORAL
		if Vector2(1.2,1.2) > scale:
			MoveLib.change_scale(self, Vector2(1.2,1.2))

func normalize() -> void:
	modulate = default_color
	MoveLib.change_scale(self, default_size)

func shadow() -> void:
	get_child(0).show()
	var distance: Vector2 = global_position - get_viewport_rect().size/2
	get_child(0).position = distance / 30
	MoveLib.change_color(get_child(0), Color(Color.BLACK, .25-distance.length()/10000))
	MoveLib.change_scale(get_child(0), shadow_scale+distance.abs()/50000)

func shadow_hide() -> void:
	MoveLib.change_color(get_child(0), Color(Color.BLACK, 0))
	get_child(0).hide()
#endregion

#region Stats update
func shift() -> void:
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
	Combat.update(self)
	check_death()


func apply_slot_effects() -> void:
	health = health + slot.health
	phys_attack = phys_attack + slot.phys_attack 
	mag_attack = mag_attack + slot.mag_attack 
	phys_defense = phys_defense + slot.phys_defense 
	mag_defense = mag_defense + slot.mag_defense 
	speed = speed + slot.speed
	tags.append_array(slot.tags)
	Combat.update(self)
	check_death()

func remove_slot_effects() -> void:
	health = health - slot.health
	phys_attack = phys_attack - slot.phys_attack
	mag_attack = mag_attack - slot.mag_attack 
	phys_defense = phys_defense - slot.phys_defense 
	mag_defense = mag_defense - slot.mag_defense 
	speed = speed - slot.speed
	for i in slot.tags.size():
		tags.erase(slot.tags[i])
	Combat.update(self)
	check_death()

func pos_apply() -> void:
	health = health + pos_health
	phys_attack = phys_attack + pos_phys_attack 
	mag_attack = mag_attack + pos_mag_attack 
	phys_defense = phys_defense + pos_phys_defense 
	mag_defense = mag_defense + pos_mag_defense 
	speed = speed + pos_speed
	tags.append_array(pos_tags)
	Combat.update(self)
	check_death()

func pos_remove() -> void:
	health = health - pos_health
	phys_attack = phys_attack - pos_phys_attack 
	mag_attack = mag_attack - pos_mag_attack 
	phys_defense = phys_defense - pos_phys_defense 
	mag_defense = mag_defense - pos_mag_defense 
	speed = speed - pos_speed
	for i in pos_tags.size():
		tags.erase(pos_tags[i])
	Combat.update(self)
	check_death()
#endregion

#region Combat
#function is formatted this way so that it is readable and customizable, keeping it in per card allows for more control
func get_target() -> Card:
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

func get_ally() -> Card:
	if friendly:
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
	else:
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

func damage_physical(damage: int) -> int:
	var change = damage - phys_defense
	if change > 0:
		health = health-change
	else:
		health = health - 1
		change = 1
	check_death()
	return change

func direct_damage_physical(damage: int) -> int:
	var change = damage - phys_defense
	if change > 0:
		health = health-change
	else:
		health = health - 1
		change = 1
	check_death()
	return change

func damage_magical(damage: int) -> int:
	var change = damage - mag_defense
	if change > 0:
		health = health-change
	else:
		health = health - 1
		change = 1
	check_death()
	return change

func direct_damage_magical(damage: int) -> int:
	var change = damage - mag_defense
	if change > 0:
		health = health-change
	else:
		health = health - 1
		change = 1
	check_death()
	return change

func damage_true(change: int) -> int:
	health = health - change
	check_death()
	return change

func direct_damage_true(change: int) -> int:
	health = health - change
	check_death()
	return change

func check_death() -> void:
	if health <= 0:
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
				elem.queue_free()
		slot.cards_list.erase(self)
		slot.update_accepting()
		await get_tree().create_timer(.125).timeout
		self.queue_free()

func kill() -> void:
	for status in statuses:
		status.queue_free()
	statuses.clear()
	for array in Combat.arrays:
		while array.has(self):
			array.erase(self)
	for elem in Combat.slots:
		while elem.cards_list.has(self):
			elem.cards_list.erase(self)
	await get_tree().create_timer(.125).timeout
	self.queue_free()

func action() -> void:
	if is_instance_valid(slot):
		slot.action()
	for status in statuses:
		Status.call_status(status, 1)
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

func default_action() -> void:
	var _enemy: Card = get_target()
	var _ally: Card = get_ally()
	var _damage: int = (Combat.RNG.randi_range(1,10))
	var ability: int = Combat.RNG.randi_range(1,5)
	match ability:
		1:
			pass
		2:
			pass
		3:
			pass
		4: 
			pass
		5:
			pass

#Should normally be called when standing in the front
func front_action() -> void:
	default_action()

#Should normally be called when standing in the center
func center_action() -> void:
	default_action()

#Should normally be called when standing in the center
func back_action() -> void:
	default_action()

#Should normally never be called as long as the card is in a slot
func shifted_default_action() -> void:
	default_action()

#Should normally be called when standing in the front
func shifted_front_action() -> void:
	shifted_default_action()

#Should normally be called when standing in the center
func shifted_center_action() -> void:
	shifted_default_action()

#Should normally be called when standing in the center
func shifted_back_action() -> void:
	shifted_default_action()
#endregion
