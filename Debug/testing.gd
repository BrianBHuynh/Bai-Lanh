extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combat.player_party.clear();
	combat.opposing_party.clear();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
