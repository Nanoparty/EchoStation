extends Area2D



func _ready():
	pass # Replace with function body.
	
func activate():
	$Sprite.frame = 1


func _on_Lever1_body_entered(body):
	print("lever1 hit")
	if body is Bullet:
		print("Lever hit by bullet")
		body.destroy()
		$Sprite.frame = 1
		var node = get_tree()
		node.get_root().get_children()[0].get_node("Level").get_node("Player").set_lever1()
		print("tree: " , node.get_root().get_children()[0].get_node("Level").get_node("Player"))
