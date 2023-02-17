extends Area2D




func _on_Key1_body_entered(body):
	if PlayerStats.sfx:
		$Pickup.play()
	body.pickup_Key1()
	queue_free()
