extends Node2D

const LIMIT_LEFT = -315
const LIMIT_TOP = -250
const LIMIT_RIGHT = 955
const LIMIT_BOTTOM = 690

func _ready():
	$FadeInTween.interpolate_property($FadeIn/Blackscreen, "modulate", Color(0,0,0,1), Color(0,0,0,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FadeInTween.start()
	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM
