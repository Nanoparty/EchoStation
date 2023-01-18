extends Area2D



func _on_Key3_body_entered(body):
	body.key3 = true
	queue_free()
