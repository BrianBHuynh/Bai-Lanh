extends Area2D

var health: int = 75 #Health amount of card
var attack: int = 10 #Attack value of the card
var defense: int = 8 #Defense of the card
var speed: int = 8 #Speed of the card

#Position stats/effects should only be applied when the play button is pressed!
var prefPos: Array = [] #Prefered possitions of the card
var pos: String = "None" #Current position
var posHealth: int = 0
var posAttack: int = 0
var posDefense: int = 0
var posSpeed: int = 0

var draggable: bool = false #If the card is draggable at that moment
var slot #Where the current slot is stored

var newSlot #Where a possible slot is

var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var initialPos: Vector2 #Location of card starting scene
var curPosition

var defaultColor: Color = modulate #for default color
var defaultSize: Vector2 = Vector2(1,1) #Default size for the card

var summon = preload("res://Current/Card/Generic Allies/Mysterious shadow worm/Mysterious Shadow Worm.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialPos = global_position
	curPosition = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	cards.moveScript(self) #Takes care of card movement each frame

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

func action():
	var enemy = combat.getNext(combat.opposingParty)
	var damage = (combat.RNG.randi_range(1,10)+attack)
	var ability = combat.RNG.randi_range(1,5)
	match ability:
		1:
			combatLib.multiPhysAttack(self, enemy, attack, 5, 4)
		2:
			combatLib.physAttack(self, enemy, damage-2)
		3:
			combatLib.physAttack(self, enemy, damage-3)
		4: 
			combatLib.physAttack(self, enemy, damage-5)
		5:
			var instance = summon.instantiate()
			get_parent().add_child(instance)
			instance.newSlot = slot
			cards.placeSlotPlayer(instance)
			combat.addInitiative(instance)
