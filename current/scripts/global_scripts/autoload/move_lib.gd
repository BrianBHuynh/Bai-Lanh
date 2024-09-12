extends Node

var tween
var animRunning = false

func move(card, destination):
	tween = get_tree().create_tween()
	animRunning = true
	tween.tween_property(card,"position",destination,0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	animRunning = false

func move_fast(card, destination):
	tween = get_tree().create_tween()
	tween.tween_property(card,"position",destination,0.075).set_ease(Tween.EASE_OUT)

func move_to_initial_pos(card):
	tween = get_tree().create_tween()
	animRunning = true
	tween.tween_property(card,"position",card.initial_pos,0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	animRunning = false

func move_then_return(card, destination):
	if is_instance_valid(card):
		tween = get_tree().create_tween()
		tween.tween_property(card,"position",destination,0.075).set_ease(Tween.EASE_OUT)
		await tween.finished
		tween = get_tree().create_tween()
		tween.tween_property(card,"position",card.current_position,0.2).set_ease(Tween.EASE_OUT)

func change_scale(card, size):
	if is_instance_valid(card):
		tween = get_tree().create_tween()
		tween.tween_property(card,"scale",size,0.1).set_ease(Tween.EASE_OUT)
