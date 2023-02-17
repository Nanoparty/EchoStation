extends Control

func _ready():
	$VBoxContainer/MusicButton.grab_focus()
	if !PlayerStats.music:
		$VBoxContainer/MusicButton.text = "MUSIC OFF"
	if !PlayerStats.sfx:
		$VBoxContainer/SoundsButton.text = "SFX OFF"

func _on_MusicButton_pressed():
	if PlayerStats.sfx:
		$Confirm.play()
	var text = $VBoxContainer/MusicButton.text
	if text == "MUSIC OFF":
		$VBoxContainer/MusicButton.text = "MUSIC ON"
		PlayerStats.music = true
		get_tree().get_root().get_node("Menu").get_node("MenuMusic").play()
	else:
		$VBoxContainer/MusicButton.text = "MUSIC OFF"
		PlayerStats.music = false
		get_tree().get_root().get_node("Menu").get_node("MenuMusic").stop()

func _on_SoundsButton_pressed():
	var text = $VBoxContainer/SoundsButton.text
	if text == "SFX OFF":
		$VBoxContainer/SoundsButton.text = "SFX ON"
		PlayerStats.sfx = true
	else:
		$VBoxContainer/SoundsButton.text = "SFX OFF"
		PlayerStats.sfx = false
	if PlayerStats.sfx:
		$Confirm.play()

func _on_ApplyButton_pressed():
	get_tree().get_root().get_node("Menu").show_menu()
	if PlayerStats.sfx:
		get_tree().get_root().get_node("Menu").get_node("Confirm").play()
	var options = get_tree().get_root().get_node("Menu").get_node("Options")
	options.queue_free()


func _on_MusicButton_focus_entered():
	if PlayerStats.sfx:
		$Selector.play()


func _on_SoundsButton_focus_entered():
	if PlayerStats.sfx:
		$Selector.play()


func _on_ApplyButton_focus_entered():
	if PlayerStats.sfx:
		$Selector.play()
