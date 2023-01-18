extends Area2D



func _on_DoubleJump_body_entered(body):
	body.canDoubleJump = true
	queue_free()
