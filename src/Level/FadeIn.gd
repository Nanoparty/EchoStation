extends CanvasLayer


func _ready():
	print("hahahah")
	$FadeInTween.interpolate_property($Blackscreen, "modulate", Color(0,0,0,1), Color(0,0,0,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
