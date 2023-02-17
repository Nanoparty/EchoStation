extends Area2D



func _on_Key2_body_entered(body):
	if PlayerStats.sfx:
		$Pickup.play()
	body.pickup_Key2()
	queue_free()
