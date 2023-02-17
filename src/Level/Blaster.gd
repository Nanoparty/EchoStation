extends Area2D



func _on_Blaster_body_entered(body):
	if PlayerStats.sfx:
		$Pickup.play()
	body.set_canShoot()
	queue_free()
