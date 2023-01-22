class_name Bullet
extends RigidBody2D


onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("attack")
	print("ready")

func destroy():
	print("destroy bullet")
	queue_free()
	#animation_player.play("destroy")


func _on_body_entered(body):
	if body is Enemy:
		body.destroy()
		queue_free()
	if body is Boss1:
		body.take_damage()
		queue_free()
	
