extends Node2D
class_name ShadersLib

static func damage_normal(card: Card, target: Card):
	target.animate = true
	var temp_material = null
	if is_instance_valid(target.get_child(3).material):
		temp_material = target.get_child(3).material
	target.get_child(3).material = load("res://current/resources/shaders/damage/damage.tres")
	target.get_child(3).material.set_shader_parameter("direction", (target.position.direction_to(card.position)))
	await target.get_tree().create_timer(2).timeout
	if is_instance_valid(target):
		if is_instance_valid(temp_material):
			target.get_child(3).material = temp_material
		else:
			target.get_child(3).material = null
