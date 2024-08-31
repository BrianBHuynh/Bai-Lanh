extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat.playerParty.clear();
	combat.opposingParty.clear();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
