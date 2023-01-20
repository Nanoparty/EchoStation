extends Area2D



func _on_Key2_body_entered(body):
	body.pickup_Key2()
	queue_free()
