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
	var drone3 = load("res://src/Actors/LaserDrone3.tscn").instance()
	get_tree().get_root().get_node("Game").get_node("Level").add_child(drone3)

func end_laser():
	$Laser.stop()
	get_node("LaserBeam").queue_free()
	spawn_next()
	queue_free()
	
func spawn_laser():
	if PlayerStats.sfx:
		$Laser.play()
	var laser = load("res://src/Actors/LaserBeam.tscn").instance()
	add_child(laser)
	laser.set_global_position(Vector2(position.x - 500, position.y))


func _on_Timer_timeout():
	$AnimationPlayer.play("attack")
