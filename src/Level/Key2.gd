extends Area2D



func _on_Key2_body_entered(body):
	body.key2 = true
	queue_free()
