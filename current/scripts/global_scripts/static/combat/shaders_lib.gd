extends Node2D
class_name ShadersLib

static func apply_shader(card: Card, target: Card, shader: String) -> void:
	target.material = load(shader).duplicate()
	target.material.set_shader_parameter("direction", (target.position.direction_to(card.position)))

static func get_shader(shader_name: String) -> String:
	match shader_name:
		"Damage": 
			return "res://current/resources/shaders/damage/damage.tres"
		_: 
			return "res://current/resources/shaders/blank/blank.tres"
