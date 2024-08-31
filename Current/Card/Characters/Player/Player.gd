extends Area2D

var health = 100 #Health amount of card
var attack = 10 #Attack value of the card
var defense = 10 #Defense of the card
var speed = 10 #Speed of the card

#Position stats/effects should only be applied when the play button is pressed!
var prefPos = [] #Prefered possitions of the card
var pos = "None" #Current position
var posHealth = 0
var posAttack = 0
var posDefense = 0
var posSpeed = 0

var draggable = false #If the card is draggable at that moment
var slotted = 0 #Slotted is a int because sometimes multiple slots overlap or are placed close to eachother
var newSlot #Where the latest slot is stored
var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var initialPos: Vector2 #The initial position of the card before moving
var curSlot #Where the current slot / location is stored
var defaultColor = modulate #for default color
var defaultSize = Vector2(1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if draggable: #Prevents alot of unecessary checks, uses select and unselect cards to make sure that the card is draggable
		if Input.is_action_just_pressed("leftClick"):
			cards.pickupCard(self)
		if Input.is_action_pressed("leftClick"):
			cards.holdCard(self)
		elif Input.is_action_just_released("leftClick"):
			modulate = defaultColor;
			globalVars.draggingCard = false
			var tween = get_tree().create_tween()
			if slotted > 0 && is_instance_valid(newSlot) && not newSlot.filled:
				cards.placeCard(self, tween)
			else:
				cards.returnCard(self, tween)

#For when the card enters a slto
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Slot'):
		cards.addSlot(self, body)

#For when the card leaves a slot
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('Slot'):
		cards.removeSlot(self)

#For when mouse enters the card
func _on_mouse_entered() -> void:
	cards.selectCard(self)

#For when mouse leaves the card
func _on_mouse_exited() -> void:
	cards.unselectCard(self)

#For when the positional effect is activated for the card
func posEffect(position):
	pass
