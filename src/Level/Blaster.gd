extends Area2D



func _on_Blaster_body_entered(body):
	body.set_canShoot()
	queue_free()
