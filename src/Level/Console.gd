extends Area2D






func _on_Console_body_entered(body):
	print("console collision")
	body.enter_computer()


func _on_Console_body_exited(body):
	body.exit_computer()
