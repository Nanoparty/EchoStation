extends TextureRect


func _ready():
	$FadeInTween.interpolate_property($".", "modulate", Color(0,0,0,1), Color(0,0,0,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
