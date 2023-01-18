extends Area2D



func _on_Blaster_body_entered(body):
	body.canShoot = true
	queue_free()
