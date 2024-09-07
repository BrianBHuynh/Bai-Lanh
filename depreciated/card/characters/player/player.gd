extends Area2D

var health: int = 100 #Health amount of card
var attack: int = 10 #Attack value of the card
var defense: int = 10 #Defense of the card
var speed: int = 10 #Speed of the card

#Position stats/effects should only be applied when the play button is pressed!
var prefPos: Array = [] #Prefered possitions of the card
var pos: String = "None" #Current position
var posHealth: int = 0
var posAttack: int = 0
var posDefense: int = 0
var posSpeed: int = 0

var buttonPressed = false
var draggable: bool = false #If the card is draggable at that moment
var slot #Where the current slot is stored

var newSlot #Where a possible slot is

var offset: Vector2 #Used to store the offset between where the card is held and the mouse
var initialPos: Vector2 #Location of card starting scene
var curPosition

var defaultColor: Color = modulate #for default color
var defaultSize: Vector2 = Vector2(1,1) #Default size for the card

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialPos = global_position
	curPosition = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if buttonPressed:
		moveLib.moveFast(self, get_global_mouse_position() - offset)
		self.move_to_front()

#For when the positional effect is activated for the card
func posEffect(position):
	pass

func action():
	var enemy = combat.getNext(combat.opposingParty)
	var damage = (combat.RNG.randi_range(1,10)+attack)
	var ability = combat.RNG.randi_range(1,4)
	match ability:
		1:
			combatLib.multiPhysAttack(self, enemy, attack-1, 7, 5)
			combatLib.lockDown(self, enemy)
		2:
			combatLib.physAttack(self, enemy, damage/2)
			combatLib.lockDown(self, enemy)
		3:
			combatLib.physAttack(self, enemy, damage)
		4:
			if defense < 15:
				defense = defense + 2
				combatLib.lockDown(self, enemy)
			combatLib.physAttack(self, enemy, damage-2)


func _on_button_pressed() -> void:
	pass


func _on_button_button_down() -> void:
	buttonPressed = true


func _on_button_button_up() -> void:
	buttonPressed = false
