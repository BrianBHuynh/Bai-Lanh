extends Node

var tween: Tween
var animRunning: bool = false

func move(card: Card, destination: Vector2) -> void:
	tween = get_tree().create_tween()
	animRunning = true
	tween.tween_property(card,"position",destination,0.3).set_ease(Tween.EASE_OUT)
	await tween.finished
	animRunning = false

func move_fast(card: Card, destination: Vector2) -> void:
	tween = get_tree().create_tween()
	tween.tween_property(card,"position",destination,0.075).set_ease(Tween.EASE_OUT)

func move_to_initial_pos(card: Card) -> void:
	tween = get_tree().create_tween()
	animRunning = true
	tween.tween_property(card,"position",card.initial_pos,0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	animRunning = false

func move_then_return(card: Card, destination: Vector2) -> void:
	if is_instance_valid(card):
		tween = get_tree().create_tween()
		tween.tween_property(card,"position",destination,0.075).set_ease(Tween.EASE_OUT)
		await tween.finished
		tween = get_tree().create_tween()
		Cards.fix_slot(card.slot)

func change_scale(card: Node2D, size: Vector2) -> void:
	if is_instance_valid(card):
		tween = get_tree().create_tween()
		tween.tween_property(card,"scale",size,0.1).set_ease(Tween.EASE_OUT)

func change_color(card: Node2D, color: Color) -> void:
	if is_instance_valid(card):
		tween = get_tree().create_tween()
		tween.tween_property(card,"modulate",color,0.15).set_ease(Tween.EASE_OUT)
