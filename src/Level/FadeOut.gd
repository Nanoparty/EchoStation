extends CanvasLayer


func fade_out():
	$FadeOutTween.interpolate_property($Blackout, "modulate", Color(0,0,0,0), Color(0,0,0,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FadeOutTween.start()
	get_tree().get_root().get_node("Game").get_node("Level").get_node("FadeOutTimer").start()


func _on_FadeOutTimer_timeout():
	get_tree().change_scene("res://src/Menu/End.tscn")
