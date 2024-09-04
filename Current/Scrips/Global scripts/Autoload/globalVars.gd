extends Node2D


var draggingCard:bool = false
var allCards: Array = []
var stackingDistance: int = 50
var curCard: Array = []

func _process(delta: float) -> void:
	if not Input.is_anything_pressed():
		globalVars.draggingCard = false
