extends Control

onready var textbox = $TextBoxLayer/Textbox
onready var fadeout = false

func _ready():
	$VBoxContainer/StartButton.grab_focus()
	
func _process(delta):
	if textbox.complete and not fadeout:
		print("complete")
		fadeout = true
		$Tween2.interpolate_property($Blackscreen, "modulate", Color(0,0,0,0), Color(0,0,0,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween2.start()
	
func hide_menu():
	print("hide menu")
	$VBoxContainer/StartButton.hide()
	$VBoxContainer/OptionsButton.hide()
	$VBoxContainer/QuitButton.hide()
	
func show_menu():
	print("show menu")
	$VBoxContainer/StartButton.show()
	$VBoxContainer/OptionsButton.show()
	$VBoxContainer/QuitButton.show()
	$VBoxContainer/StartButton.grab_focus()

func _on_StartButton_pressed():
	$Tween.interpolate_property($VBoxContainer/StartButton, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($VBoxContainer/OptionsButton, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($VBoxContainer/QuitButton, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Title, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($copyright, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	$VBoxContainer/StartButton.disabled = true
	$VBoxContainer/OptionsButton.disabled = true
	$VBoxContainer/QuitButton.disabled = true
	


func _on_OptionsButton_pressed():
	hide_menu()
	var options = load("res://src/Menu/Options.tscn").instance()
	get_tree().current_scene.add_child(options)
	
func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Tween_tween_all_completed():
	textbox.queue_text("Location: Sol System, Outer Belt")
	textbox.queue_text("Date: December 25, 2077")
	textbox.queue_text("Name: Echo Station")
	textbox.queue_text("Status: Condemned")
	textbox.queue_text("Last Recorded Visit: %&#*%&#!$...")
	textbox.queue_text("[ERROR - SYSTEM FAILURE]")


func _on_Tween2_tween_all_completed():
	get_tree().change_scene("res://src/Main/Game.tscn")
