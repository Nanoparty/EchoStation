extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Lever3_body_entered(body):
	print("lever3 hit")
	if body is Bullet:
		print("Lever hit by bullet")
		body.destroy()
		$Sprite.frame = 1
		var node = get_tree()
		node.get_root().get_children()[0].get_node("Level").get_node("Player").set_lever3()
		print("tree: " , node.get_root().get_children()[0].get_node("Level").get_node("Player"))
