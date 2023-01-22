extends CanvasLayer


func fade_out():
	$FadeInTween.interpolate_property($FadeOutBlack, "modulate", Color(0,0,0,0), Color(0,0,0,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FadeInTween.start()
	get_tree().get_root().get_node("Game").get_node("Level").get_node("FadeOutTimer").start()


func _on_FadeOutTimer_timeout():
	get_tree().change_scene("res://src/Main/Game.tscn")
