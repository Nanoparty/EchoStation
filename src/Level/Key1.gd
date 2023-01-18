extends Area2D




func _on_Key1_body_entered(body):
	body.key1 = true
	queue_free()
