extends StaticBody2D

var filled = false
var pos = "Default"
var posHealth = 100
var posAttack = 10
var posDefense = 0
var posSpeed = 0

var cardsList: Array = []
var accepting: bool = true

var defaultColor = modulate
var defaultSize = scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat.slots.append(self)
	modulate = Color(Color.ALICE_BLUE, .7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not cardsList.is_empty():
		accepting = false
	elif cardsList.is_empty() and accepting == false:
		accepting = true

func action():
	pass
