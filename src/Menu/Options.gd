extends Control

func _ready():
	$VBoxContainer/MusicButton.grab_focus()

func _on_MusicButton_pressed():
	var text = $VBoxContainer/MusicButton.text
	if text == "MUSIC OFF":
		$VBoxContainer/MusicButton.text = "MUSIC ON"
	else:
		$VBoxContainer/MusicButton.text = "MUSIC OFF"

func _on_SoundsButton_pressed():
	var text = $VBoxContainer/SoundsButton.text
	if text == "SFX OFF":
		$VBoxContainer/SoundsButton.text = "SFX ON"
	else:
		$VBoxContainer/SoundsButton.text = "SFX OFF"

func _on_ApplyButton_pressed():
	get_tree().get_root().get_node("Menu").show_menu()
	var options = get_tree().get_root().get_node("Menu").get_node("Options")
	options.queue_free()
