extends StaticBody2D



func _on_Area2D_body_entered(body):
	if body is Player:
		body.enter_door()


func _on_Area2D_body_exited(body):
	if body is Player:
		body.exit_door()
