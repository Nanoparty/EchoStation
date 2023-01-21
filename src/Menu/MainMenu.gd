extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()
	
func hide_menu():
	$VBoxContainer/StartButton.hide()
	$VBoxContainer/OptionsButton.hide()
	$VBoxContainer/QuitButton.hide()
	
func show_menu():
	$VBoxContainer/StartButton.show()
	$VBoxContainer/OptionsButton.show()
	$VBoxContainer/QuitButton.show()
	$VBoxContainer/StartButton.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene("res://src/Level/TestLevel.tscn")

func _on_OptionsButton_pressed():
	var options = load("res://src/Menu/Options.tscn").instance()
	get_tree().current_scene.add_child(options)
	
func _on_QuitButton_pressed():
	get_tree().quit()
