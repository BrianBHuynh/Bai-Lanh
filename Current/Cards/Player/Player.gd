extends Node2D

var health: int = 100 #Health amount of card
var physAttack: int = 10 #physical Attack value of the card
var magAttack: int = 10 #Magic attack value of the card
var physDefense: int = 10 #Physical defense of the card
var magDefense: int = 10 #Magical defense of the card
var speed: int = 10 #Speed of the card

#Position stats/effects should only be applied when the play button is pressed!
var prefPos: Array = [] #Prefered possitions of the card
var pos: String = "None" #Current position

#Stats changed for being in the prefered positions
var posHealth: int = 0
var posAttack: int = 0
var posDefense: int = 0
var posSpeed: int = 0

var slot #Where the current slot is stored
var newSlot #Where a possible slot is

var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var curPosition #Where the card is currently resting, set at the start to where the card enters the scene tree for the first time

var defaultColor: Color = modulate #for default color
var defaultSize: Vector2 = Vector2(1,1) #Default size for the card

var held: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curPosition = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if held == true:
		cards.holdCard(self)


func _on_card_held() -> void:
	held = true
	cards.holdCard(self)


func _on_card_released() -> void:
	held = false
	cards.releaseCard(self)


func _on_body_entered(body: Node2D) -> void:
	cards.addSlot(self, body)


func _on_area_entered(area: Area2D) -> void:
	cards.addCard(self, area)


func _on_body_exited(body: Node2D) -> void:
	cards.removeSlot(self, body)


func _on_area_exited(area: Area2D) -> void:
	cards.removeCard(self, area)

func _on_mouse_entered() -> void:
	cardHighlight()

func _on_mouse_exited() -> void:
	cardNormalize()

func cardHighlight():
	modulate = Color(Color.PALE_GOLDENROD)
	scale = Vector2(1.5,1.5)

func cardNormalize():
	modulate = defaultColor
	scale = defaultSize

func action():
	if is_instance_valid(slot):
		slot.action()
	if pos == "front":
		frontAction()
	elif pos == "center":
		centerAction()
	elif pos == "back":
		backAction()
	else:
		defaultAction()

func defaultAction():
	pass #Should normally never be called as long as the card is in a slot

func frontAction():
	pass #Should normally be called when standing in the front

func centerAction():
	pass #Should normally be called when standing in the center

func backAction():
	pass #Should normally be called when standing in the center
