extends Node
class_name MoveLib

static func move(node: Node2D, destination: Vector2) -> void:
	var tween = node.get_tree().create_tween()
	tween.tween_property(node,"position",destination,0.3).set_ease(Tween.EASE_OUT)

static func move_fast(node: Node2D, destination: Vector2) -> void:
	var tween = node.get_tree().create_tween()
	tween.tween_property(node,"position",destination,0.075).set_ease(Tween.EASE_OUT)

static func move_to_initial_pos(card: Card) -> void:
	var tween = card.get_tree().create_tween()
	tween.tween_property(card,"position",card.initial_pos,0.2).set_ease(Tween.EASE_OUT)

static func move_then_return(card: Card, destination: Vector2) -> void:
	if is_instance_valid(card):
		var tween = card.get_tree().create_tween()
		tween.tween_property(card,"position",destination,0.075).set_ease(Tween.EASE_OUT)
		await tween.finished
		card.slot.fix_slot()

static func change_scale(card: Node2D, size: Vector2) -> void:
	if is_instance_valid(card):
		var tween = card.get_tree().create_tween()
		tween.tween_property(card,"scale",size,0.1).set_ease(Tween.EASE_OUT)

static func change_color(card: Node2D, color: Color) -> void:
	if is_instance_valid(card):
		var tween = card.get_tree().create_tween()
		tween.tween_property(card,"modulate",color,0.15).set_ease(Tween.EASE_OUT)
