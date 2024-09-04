extends StaticBody2D

var filled = false
var pos = "Default"
var posHealth = 0
var posAttack = 0
var posDefense = 0
var posSpeed = 0

var cards: Array = []
var accepting: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(Color.ALICE_BLUE, .7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
