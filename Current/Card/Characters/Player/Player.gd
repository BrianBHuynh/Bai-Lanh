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
var carded = 0 #Like the above variable however applies to cards, needs to be seperated since slots take priority over cards
var newSlot #Where the latest slot is stored
var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var initialPos: Vector2 #The initial position of the card before moving
var curSlot #Where the current slot / location is stored
var defaultColor = modulate #for default color
var defaultSize = Vector2(1,1)

var cardAbove = null
var cardBelow
var bottomCard = self
var newCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialPos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if self.cardAbove == self:
		scale = Vector2(5,5)
	cards.move(self) #Takes care of card movement each frame

#For when the card enters a slot
func _on_body_entered(body: Node2D) -> void:
	cards.addSlot(self, body)

#For when the card enters another card
func _on_area_entered(area: Area2D) -> void:
	cards.addCard(self, area)

#For when the card leaves a slot
func _on_body_exited(body: Node2D) -> void:
	cards.removeSlot(self, body)

#For when the card leaves another card
func _on_area_exited(area: Area2D) -> void:
	cards.removeCard(self, area)

#For when mouse enters the card
func _on_mouse_entered() -> void:
	cards.mouseOver(self)

#For when mouse leaves the card
func _on_mouse_exited() -> void:
	cards.mouseOff(self)

#For when the positional effect is activated for the card
func posEffect(position):
	pass
