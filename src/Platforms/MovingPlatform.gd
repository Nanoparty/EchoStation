extends KinematicBody2D
onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Moving")
	print("ready")
