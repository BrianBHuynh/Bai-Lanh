extends Node2D
class_name ShadersLib

static func damage_normal(card: Card, target: Card):
	target.material = load("res://current/resources/shaders/damage/damage.tres").duplicate()
	target.material.set_shader_parameter("direction", (target.position.direction_to(card.position)))
