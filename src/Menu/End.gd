extends Control

onready var enemiesText = $CanvasLayer/VBoxContainer/Enemies
onready var deathsText = $CanvasLayer/VBoxContainer/Deaths
onready var coinsText = $CanvasLayer/VBoxContainer/Coins
onready var scoreText = $CanvasLayer/VBoxContainer/Score
onready var continueButton = $CanvasLayer/VBoxContainer/Continue
onready var timer = $Timer

onready var numEnemies = PlayerStats.enemies
onready var numDeaths = PlayerStats.deaths
onready var numCoins = PlayerStats.coins

onready var score = 0
onready var state = 0

func _ready():
	continueButton.disabled = true
	continueButton.hide()
	
	score = (10 * numEnemies) - (10 * numDeaths) + numCoins


func _on_Timer_timeout():
	if state == 0:
		enemiesText.text = "Enemies Defeated: " + str(numEnemies)
		state = 1
		$EnemyTween.interpolate_property(enemiesText, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$EnemyTween.start()
		timer.start()
		return
	if state == 1:
		deathsText.text = "Lives Lost: " + str(numDeaths)
		state = 2
		$DeathTween.interpolate_property(deathsText, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$DeathTween.start()
		timer.start()
		return
	if state == 2:
		coinsText.text = "Coins Collected: " + str(numCoins)
		state = 3
		$CoinTween.interpolate_property(coinsText, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$CoinTween.start()
		timer.start()
		return
	if state == 3:
		scoreText.text = "Score:" + str(score)
		state = 4
		$ScoreTween.interpolate_property(scoreText, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$ScoreTween.start()
		timer.start()
		return
	if state == 4:
		continueButton.show()
		continueButton.disabled = false
		continueButton.grab_focus()
		$ContinueTween.interpolate_property(continueButton, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$ContinueTween.start()


func _on_Continue_pressed():
	get_tree().change_scene("res://src/Menu/Credits.tscn")
