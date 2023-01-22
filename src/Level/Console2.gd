extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var canCollide = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Console2_body_entered(body):
	if body is Boss1:
		return
	if body is Bullet:
		return
	if canCollide:
		body.enter_final()


func _on_Console2_body_exited(body):
	if body is Boss1:
		return
	if body is Bullet:
		return
	if canCollide:
		body.exit_final()
