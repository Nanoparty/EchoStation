extends Area2D



func _on_Key3_body_entered(body):
	if PlayerStats.sfx:
		$Pickup.play()
	body.pickup_Key3()
	queue_free()
