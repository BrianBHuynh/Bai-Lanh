extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalVars.player_party.clear();
	globalVars.opposing_party.clear();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if is_instance_valid(GlobalVars.player_party.front()):
		#GlobalVars.player_party.pop_front().duplicate()
	pass
