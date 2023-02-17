extends Area2D



func _on_DoubleJump_body_entered(body):
	if PlayerStats.sfx:
		$Pickup.play()
	body.set_canDoubleJump()
	queue_free()
