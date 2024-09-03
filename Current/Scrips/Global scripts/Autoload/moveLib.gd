extends Node2D

var tween
var animRunning = false

func move(card, destination):
	tween = get_tree().create_tween()
	animRunning = true
	tween.tween_property(card,"position",destination,0.2).set_ease(Tween.EASE_OUT)
	await tween.finished
	animRunning = false
