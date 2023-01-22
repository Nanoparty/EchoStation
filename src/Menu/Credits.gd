extends Control

onready var programming = $CanvasLayer/VBoxContainer/ProgrammingDesign
onready var nathan = $CanvasLayer/VBoxContainer/Nathan
onready var art = $CanvasLayer/VBoxContainer/Art
onready var artPack = $CanvasLayer/VBoxContainer/ArtPack
onready var music = $CanvasLayer/VBoxContainer/Music
onready var menu = $CanvasLayer/VBoxContainer/MenuMusic
onready var song1 = $CanvasLayer/VBoxContainer/Song1
onready var song2 = $CanvasLayer/VBoxContainer/Song2
onready var boss = $CanvasLayer/VBoxContainer/BossMusic

onready var continueButton = $CanvasLayer/VBoxContainer/Continue

onready var timer = $Timer

onready var state = 0

func _ready():
	continueButton.disabled = true
	continueButton.hide()


func _on_Timer_timeout():
	if state == 0:
		state = 1
		$Tween1.interpolate_property(programming, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween1.start()
		timer.start()
		return
	if state == 1:
		state = 2
		$Tween2.interpolate_property(nathan, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween2.start()
		timer.start()
		return
	if state == 2:	
		state = 3
		$Tween3.interpolate_property(art, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween3.start()
		timer.start()
		return
	if state == 3:		
		state = 4
		$Tween4.interpolate_property(artPack, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween4.start()
		timer.start()
		return
	if state == 4:		
		state = 5
		$Tween5.interpolate_property(music, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween5.start()
		timer.start()
		return
	if state == 5:		
		state = 6
		$Tween6.interpolate_property(menu, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween6.start()
		timer.start()
		return
	if state == 6:		
		state = 7
		$Tween7.interpolate_property(song1, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween7.start()
		timer.start()
		return
	if state == 7:		
		state = 8
		$Tween9.interpolate_property(boss, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween9.start()
		timer.start()
		return
	if state == 8:
		continueButton.show()
		continueButton.disabled = false
		continueButton.grab_focus()
		$Tween10.interpolate_property(continueButton, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween10.start()


func _on_Continue_pressed():
	get_tree().change_scene("res://src/Menu/MainMenu.tscn")
