extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_next():
	get_tree().get_root().get_node("Game").get_node("Level").get_node("Boss1").end_lasers()

func end_laser():
	get_node("LaserBeam").queue_free()
	spawn_next()
	queue_free()
	
func spawn_laser():
	var laser = load("res://src/Actors/LaserBeam.tscn").instance()
	add_child(laser)


func _on_Timer_timeout():
	$AnimationPlayer.play("attack")
