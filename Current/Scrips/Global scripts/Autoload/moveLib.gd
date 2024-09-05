extends Node2D

var tween
var animRunning = false

func move(card, destination):
	tween = get_tree().create_tween()
	animRunning = true
	tween.tween_property(card,"position",destination,0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	animRunning = false

func moveFast(card, destination):
	tween = get_tree().create_tween()
	tween.tween_property(card,"position",destination,0.075).set_ease(Tween.EASE_OUT)

func moveToInitialPos(card):
	tween = get_tree().create_tween()
	animRunning = true
	tween.tween_property(card,"position",card.initialPos,0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	animRunning = false

func moveThenReturn(card, destination):
	if is_instance_valid(card):
		tween = get_tree().create_tween()
		tween.tween_property(card,"position",destination,0.075).set_ease(Tween.EASE_OUT)
		await tween.finished
		tween = get_tree().create_tween()
		tween.tween_property(card,"position",card.curPosition,0.2).set_ease(Tween.EASE_OUT)
