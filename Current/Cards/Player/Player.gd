extends Node2D

@export var card_name = "Player"

@export var health: int = 100 #Health amount of card
@export var phys_attack: int = 10 #physical Attack value of the card
@export var mag_attack: int = 10 #Magic attack value of the card
@export var phys_defense: int = 10 #Physical defense of the card
@export var mag_defense: int = 10 #Magical defense of the card
@export var speed: int = 10 #Speed of the card
@export var tags: Array = []

#Modifiers for shifting, are added or subtracted from the normal stats when shifting
@export var shifted_health: int = 100
@export var shifted_phys_attack: int = 10
@export var shifted_mag_attack: int = 10
@export var shifted_phys_defense: int = 10
@export var shifted_mag_defense: int = 10
@export var shifted_speed: int = 10
@export var shifted_tags: Array = []

#Position stats/effects should only be applied when the play button is pressed!
var pref_pos: Array = [] #Prefered possitions of the card
var pos: String = "None" #Current position

#Stats changed for being in the prefered positions
@export var pos_health: int = 0
@export var pos_attack: int = 0
@export var pos_defense: int = 0
@export var pos_speed: int = 0
@export var pos_tags: Array = []

var slot #Where the current slot is stored
var new_slot #Where a possible slot is

var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var current_position #Where the card is currently resting, set at the start to where the card enters the scene tree for the first time

var default_color: Color = modulate #for default color
var default_size: Vector2 = Vector2(1,1) #Default size for the card

var held: bool = false

@export var shifted: bool = false
@export var friendly: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if held and friendly:
		cards.hold_card(self)


func _on_card_held() -> void:
	held = true
	offset = get_global_mouse_position() - global_position
	scale = Vector2(1.5,1.5)


func _on_card_released() -> void:
	held = false
	cards.release_card(self)


func _on_body_entered(body: Node2D) -> void:
	cards.add_slot(self, body)


func _on_area_entered(area: Area2D) -> void:
	cards.add_card(self, area)


func _on_body_exited(body: Node2D) -> void:
	cards.remove_slot(self, body)


func _on_area_exited(area: Area2D) -> void:
	cards.remove_card(self, area)

func _on_mouse_entered() -> void:
	card_highlight()

func _on_mouse_exited() -> void:
	card_normalize()

func card_highlight():
	modulate = Color(Color.PALE_GOLDENROD)

func card_normalize():
	modulate = default_color
	scale = default_size

func get_target():
	if friendly:
		if shifted:
			combat.get_target(combat.opposing_party)
		else:
			combat.get_target(combat.opposing_party)
	else:
		if shifted:
			combat.get_target(combat.player_party)
		else:
			combat.get_target(combat.player_party)

func damage_physical(damage):
	if (damage - phys_defense) > 0:
		health = health-damage

func damage_magical(damage):
	if (damage - mag_defense) > 0:
		health = health-damage

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
	pass #Should normally never be called as long as the card is in a slot

func front_action():
	pass #Should normally be called when standing in the front

func center_action():
	pass #Should normally be called when standing in the center

func back_action():
	pass #Should normally be called when standing in the center

func shifted_default_action():
	pass #Should normally never be called as long as the card is in a slot

func shifted_front_action():
	pass #Should normally be called when standing in the front

func shifted_center_action():
	pass #Should normally be called when standing in the center

func shifted_back_action():
	pass #Should normally be called when standing in the center
