class_name Player
extends Actor


# warning-ignore:unused_signal
signal collect_coin()

const FLOOR_DETECT_DISTANCE = 20.0

export(String) var action_suffix = ""

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var shoot_timer = $ShootAnimation
onready var sprite = $Sprite
onready var sound_jump = $Jump
onready var gun = sprite.get_node(@"Gun")
onready var detector = $DamageDetector
onready var hpBar = $UI/HpSprite
onready var textBox = $UI/Textbox

onready var key1Icon = $UI/Key1
onready var key2Icon = $UI/Key2
onready var key3Icon = $UI/Key3

onready var interactIcon = $InteractKey
onready var compTimer = $ComputerTimer

onready var computer = get_tree().get_root().get_node("Game").get_node("Level").get_node("Interactibles").get_node("Computer")
onready var door1 = get_tree().get_root().get_node("Game").get_node("Level").get_node("Doors").get_node("Door1")
onready var door2 = get_tree().get_root().get_node("Game").get_node("Level").get_node("Doors").get_node("Door2")
onready var door3 = get_tree().get_root().get_node("Game").get_node("Level").get_node("Doors").get_node("Door3")
onready var door4 = get_tree().get_root().get_node("Game").get_node("Level").get_node("Doors").get_node("Door4")
onready var door5 = get_tree().get_root().get_node("Game").get_node("Level").get_node("Doors").get_node("Door5")
onready var respawnPoint = get_tree().get_root().get_node("Game").get_node("Level").get_node("PlayerSpawn")
onready var spikeDialog = get_tree().get_root().get_node("Game").get_node("Level").get_node("SpikeDialog")
onready var enemyDialog = get_tree().get_root().get_node("Game").get_node("Level").get_node("EnemyDialog")
onready var leverDialog = get_tree().get_root().get_node("Game").get_node("Level").get_node("LeverDialog")
onready var bossTrigger = get_tree().get_root().get_node("Game").get_node("Level").get_node("BossTrigger")
onready var bossGate = get_tree().get_root().get_node("Game").get_node("Level").get_node("BossGate")
onready var bossHealth = get_tree().get_root().get_node("Game").get_node("Level").get_node("BossHealth")
onready var bossSpawn = get_tree().get_root().get_node("Game").get_node("Level").get_node("BossSpawn")
onready var FadeOut = get_tree().get_root().get_node("Game").get_node("Level").get_node("FadeOut")
onready var FadeOutTween = get_tree().get_root().get_node("Game").get_node("Level").get_node("FadeOutTween")
onready var FadeOutTimer = get_tree().get_root().get_node("Game").get_node("Level").get_node("FadeOutTimer")
onready var keyPanels = get_tree().get_root().get_node("Game").get_node("Level").get_node("Interactibles").get_node("Key Slots")
onready var music1 = get_tree().get_root().get_node("Game").get_node("Level").get_node("Music").get_node("Music1")
onready var music2 = get_tree().get_root().get_node("Game").get_node("Level").get_node("Music").get_node("Music2")
onready var bossMusic = get_tree().get_root().get_node("Game").get_node("Level").get_node("Music").get_node("BossMusic")

onready var door1Open = false
onready var door2Open = false

onready var fadeIn = false

onready var canTriggerBoss = true

onready var health = 3
onready var dead = false
onready var jumpCount = 0
onready var canDoubleJump = false
onready var canShoot = false

onready var canMove = true

onready var key1 = false
onready var key2 = false
onready var key3 = false

onready var bossUnlocked = false
onready var bossSpawned = false

onready var lever1 = false
onready var lever2 = false
onready var lever3 = false
onready var allLeversPulled = false

onready var invulnerable = false

onready var atComputer = false
onready var atDoor = false

onready var atFinalConsole = false

onready var state = 0

onready var grounded = false


func _ready():
	# Static types are necessary here to avoid warnings.
	bossGate.get_node("CollisionShape2D").disabled = true
	bossGate.hide()
	key1Icon.hide()
	key2Icon.hide()
	key3Icon.hide()
	
	interactIcon.hide()
	
func _physics_process(_delta):
	
	if dead or textBox.pause:
		return
		
	update_keys()
	

	
	
	if textBox.complete:
		#End of starting monologue
		if state == 0:
			pass
		#Opening first door
		if state == 1:
			if PlayerStats.sfx:
				$DoorOpen.play()
			door1.queue_free()
			state = 2
			pass
		if state == 2:
			pass
		if state == 3:
			key1 = false
			if PlayerStats.sfx:
				$DoorOpen.play()
			door2.queue_free()
			state = 4
			keyPanels.frame = 1
			pass
		if state == 4:
			pass
		if state == 5:
			key2 = false
			keyPanels.frame = 2
			state = 6
			pass
		if state == 6:
			pass
		if state == 7:
			if PlayerStats.sfx:
				$DoorOpen.play()
			door5.queue_free()
			bossUnlocked = true
			keyPanels.frame = 3
			state = 8
			pass
		if state == 8:
			pass
		if state == 9:
			spawn_boss()
			bossSpawned = true
			music2.stop()
			music1.stop()
			if PlayerStats.music:
				bossMusic.play()
			state = 10
			pass
		if state == 10:
			#enable console
			pass
		if state == 11:
			pass
		if state == 12:
			#transition to end screen
			get_tree().get_root().get_node("Game").get_node("Level").fade_out()
			pass
		
			
		textBox.complete = false
	
	# Booting up Computer
	if Input.is_action_just_pressed("ui_accept") && atComputer and state == 0:
		if PlayerStats.sfx:
			$Computer_Start.play()
		computer.frame = 1
		state = 1
		atComputer = false
		interactIcon.hide()
		compTimer.start()
		
	#Talking to Alex without any keys before boss
	if Input.is_action_just_pressed("ui_accept") and atComputer and state > 0 and not key1 and not key2 and not key3 and not bossUnlocked:
		atComputer = false
		interactIcon.hide()
		textBox.queue_text("Alex: \"Find any security keys yet?\"")
		
	#Talking to Alex after all keys before boss
	if Input.is_action_just_pressed("ui_accept") and atComputer and bossUnlocked and not bossSpawned:
		atComputer = false
		interactIcon.hide()
		textBox.queue_text("Alex: \"There's something strange just below us...\"")
	
	#Talking to Alex after all keys after boss
	if Input.is_action_just_pressed("ui_accept") and atComputer and bossUnlocked and bossSpawned:
		atComputer = false
		interactIcon.hide()
		textBox.queue_text("Alex: \"Go kick his ass!\"")
		
	#Talking to Alex with key1
	if Input.is_action_just_pressed("ui_accept") and atComputer and key1:
		if PlayerStats.sfx:
			$Computer_Upgrade.play()
		atComputer = false
		computer.frame = 2
		interactIcon.hide()
		textBox.queue_text("Sparky: \"I think this is one of those security keys you wanted.\"")
		textBox.queue_text("Alex: \"Yes, it is!. Great work!\"")
		textBox.queue_text("Alex: \"I've managed to unlock some systems, but I still need the other two.\"")
		textBox.queue_text("Sparky: \"Alright, back to work.\"")
		state = 3
		
	#Talking to Alex with key2
	if Input.is_action_just_pressed("ui_accept") and atComputer and key2:
		if PlayerStats.sfx:
			$Computer_Upgrade.play()
		atComputer = false
		computer.frame = 3
		interactIcon.hide()
		textBox.queue_text("Sparky: \"I found the second key!.\"")
		textBox.queue_text("Alex: \"Excellent! We're almost done, just one more to go.\"")
		textBox.queue_text("Sparky: \"Then we can finally relax again.\"")
		state = 5
		
	#Talking to Alex with key3
	if Input.is_action_just_pressed("ui_accept") and atComputer and key3:
		if PlayerStats.sfx:
			$Computer_Upgrade.play()
		atComputer = false
		computer.frame = 4
		interactIcon.hide()
		textBox.queue_text("Sparky: \"I've got the last key!.\"")
		textBox.queue_text("Alex: \"I knew you could do it. Now lets clean up this mess the humans left.\"")
		textBox.queue_text("Alex: \"................\"")
		textBox.queue_text("Alex: \"Looks like we have a problem.\"")
		textBox.queue_text("Sparky: \"Whats wrong? Is something broken?\"")
		textBox.queue_text("Alex: \"No, but there's a mysterious firewall.\"")
		textBox.queue_text("Alex: \"It's blocking off the station's core systems.\"")
		textBox.queue_text("Alex: \"It seems to be coming from a maintenance room below us.\"")
		textBox.queue_text("Alex: \"Can you go investigate for me?.\"")
		textBox.queue_text("Sparky: \"Not like I've got anything else to do.\"")
		state = 7
		
	if Input.is_action_just_pressed("ui_accept") and atFinalConsole:
		end_game()
		
	# Door locked text
	if Input.is_action_just_pressed("ui_accept") && atDoor:
		door_locked()
		
	if !grounded && is_on_floor():
		grounded = true
		if PlayerStats.sfx:
			$GroundThud.play()
		
	if !is_on_floor():
		grounded = false;
		
	var falling = false
	# Fall through platforms
	if Input.is_action_pressed("crouch" + action_suffix) and Input.is_action_just_pressed("jump" + action_suffix) and is_on_floor():
		set_collision_mask_bit(3, false)
		falling = true
		get_node("PlatformTimer").start()
	# Play jump sound
	elif Input.is_action_just_pressed("jump" + action_suffix) and is_on_floor(): 
		if PlayerStats.sfx:
			sound_jump.play()
		
	var direction = get_direction(falling, false)

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0:
		if direction.x > 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1

	# We use the sprite's scale to store Robi’s look direction which allows us to shoot
	# bullets forward.
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.
	var is_shooting = false
	if Input.is_action_just_pressed("shoot" + action_suffix) and canShoot:
		is_shooting = gun.shoot(sprite.scale.x)
		
	#if health <= 0:
		#dead = true

	var animation = get_new_animation(is_shooting)
	set_animation(animation, is_shooting)
		
func set_animation(animation, is_shooting = false):
	if animation != animation_player.current_animation and shoot_timer.is_stopped():
		if is_shooting:
			shoot_timer.start()
		animation_player.play(animation)
		
func update_keys():
	if key1:
		key1Icon.show()
	else:
		key1Icon.hide()
	if key2:
		key2Icon.show()
	else:
		key2Icon.hide()
	if key3:
		key3Icon.show()
	else:
		key3Icon.hide()
		
func wake_up():
	textBox.queue_text("[SYSTEM DIAGNOSTICS: PROCESSES REBOOTING...]")
	textBox.queue_text("Sparky: \"Ugh...my servos feel so rusty. Where am I?\"")
	textBox.queue_text("Sparky: \"It looks like the station, but something feels wrong here...\"")
	textBox.queue_text("Sparky: \"Seems like I'm missing a few of my parts.\"")
	textBox.queue_text("Sparky: \"Looks like I'll need some reassembly.\"")
	textBox.queue_text("Sparky: \"I better go find out whats happening around here.\"")
	
func respawn_text():
	textBox.queue_text("Alex: \"Careful, spare parts don't grow on trees you know.\"")
	
func boss_kill():
	state = 11
	textBox.queue_text("Alex: \"You got him! Great fight!.\"")
	textBox.queue_text("Alex: \"Now just hit the button on that console and I can cancel the lockdown.\"")
	
func end_game():
	textBox.queue_text("[SYSTEM RESTORED...STATION LOCKDOWN ABORTED]")
	textBox.queue_text("Alex: \"You did it! You're quite the fighter.\"")
	textBox.queue_text("Sparky: \"Thanks! But I couldn't have done it without you.\"")
	textBox.queue_text("Sparky: \"Looks like we make a pretty good team.\"")
	textBox.queue_text("Alex: \"Sure does. Good thing too, because the works not done yet.\"")
	textBox.queue_text("Alex: \"There's still a lot of infected bots we have to clean up.\"")
	textBox.queue_text("Alex: \"And other bots like us who probably need rescue.\"")
	textBox.queue_text("Sparky: \"Looks like this party is just getting started...\"")
	textBox.queue_text("[SYSTEM CONNECTION LOST - GAME OVER]")
	state = 12
	
func introduction():
	textBox.queue_text("[SYSTEM REBOOT IN PROGRESS...]")
	textBox.queue_text("???: \"Welcome to Echo Station! My name is A.L.E.X.! How can I help you?\"")
	textBox.queue_text("Sparky: \"What happened here? My sensors say I've been in sleep mode for 200 years.\"")
	textBox.queue_text("Alex: \"As you can see, everything went to shit!\"")
	textBox.queue_text("Alex: \"The humans running the station left and never came back.\"")
	textBox.queue_text("Sparky: \"Why would they do that?\"")
	textBox.queue_text("Alex: \"A virus infected all of the robots on the station and they became violent.\"")
	textBox.queue_text("Alex: \"So they locked it down and fled.\"")
	textBox.queue_text("Sparky: \"Wow, guess I got lucky. Is the station still in lockdown?\"")
	textBox.queue_text("Alex: \"Yes, but I can remove it with your help.\"")
	textBox.queue_text("Alex: \"There are 3 security keys I need to break the encryption.\"")
	textBox.queue_text("Sparky: \"Alright, guess I'll go take a look and try to find them.\"")
	
func boss_introduction():
	textBox.queue_text(".........................")
	textBox.queue_text("???: \"So its you who's been messing with my station...\"")
	textBox.queue_text("Sparky: \"Who?...I'm just trying to get things back to normal.\"")
	textBox.queue_text("???: \"Quiet, I'm in charge around here.\"")
	textBox.queue_text("Sparky: \"Just listen to me, we can work together!\"")
	textBox.queue_text("???: \"If you won't be quiet, I'll just have to shut you up myself!\"")
	state = 9
	
func boss_retry():
	textBox.queue_text("Kyle: \"Back for more I see!\"")
	state = 9
	
func door_locked():
	textBox.queue_text("This door is locked.")
		
func set_canDoubleJump():
	if PlayerStats.sfx:
		$Pickup.play()
	canDoubleJump = true
	textBox.queue_text("Look at this! My old maneuvering thrusters!")
	textBox.queue_text("With these I should be able to get around a lot easier.")
	
func set_canShoot():
	if PlayerStats.sfx:
		$Pickup.play()
	canShoot = true
	textBox.queue_text("Hey! Its my old plasma cutter arm!")
	textBox.queue_text("Now I should be able to defend myself against those rogue machines.")
	
func pickup_Key1():
	if PlayerStats.sfx:
		$Pickup.play()
	key1 = true
	textBox.queue_text("This looks like the first security key!")
	textBox.queue_text("I better give this to A.L.E.X so she can unlock the station controls.")
	
func pickup_Key2():
	if PlayerStats.sfx:
		$Pickup.play()
	key2 = true
	textBox.queue_text("Nice, the second security key!")
	textBox.queue_text("Just one more to go.")
	
func pickup_Key3():
	if PlayerStats.sfx:
		$Pickup.play()
	key3 = true
	textBox.queue_text("The last security key!")
	textBox.queue_text("Now A.L.E.X should be able to fix the station.")
	textBox.queue_text("I can't wait for things to return to normal.")
	
func spawn_boss():
	print("spawn boss")
	bossHealth.show()
	var boss = load("res://src/Actors/Boss1.tscn").instance()
	get_tree().get_root().get_node("Game").get_node("Level").add_child(boss)
	boss.transform = bossSpawn.transform

func get_direction(falling, paused):
	var UpVector = 0
	
	if is_on_floor() and !falling:
		jumpCount = 0

	
	if jumpCount < 2 and !is_on_floor() and Input.is_action_just_pressed("jump" + action_suffix) and canDoubleJump:
		UpVector = -1
		jumpCount = 2
		if PlayerStats.sfx:
			sound_jump.play()

	elif jumpCount == 0 and is_on_floor() and !falling and Input.is_action_just_pressed("jump" + action_suffix):
		UpVector = -1
		jumpCount += 1

	if paused:
		UpVector = 0
		
	return Vector2(
		Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix),
		UpVector
	)


func take_damage(damage):
	print("Take Damage")
	if invulnerable:
		 return
	invulnerable = true
	$DamageTimer.start()
	
	health -= damage
	
	if health == 2:
		hpBar.frame = 2
	if health == 1:
		hpBar.frame = 1
	if health <= 0:
		hpBar.frame = 0
	
	if health > 0:
		#if PlayerStats.sfx:
		$Hit.play(0)
	else:
		#if PlayerStats.sfx:
		$Explode.play(0)
		set_animation("death")
		dead = true
		invulnerable = true
		$RespawnTimer.start()
		
func respawn():
	var r = deg2rad(180)
	$Sprite.rotate(r)
	if PlayerStats.sfx:
		$Heal.play()
	PlayerStats.deaths += 1
	transform = respawnPoint.transform
	health = 3
	hpBar.frame = 3
	dead = false
	respawn_text()
	bossMusic.stop()
	if PlayerStats.music:
		music1.play()
	canTriggerBoss = true
	if bossSpawned:
		bossHealth.hide()
		bossGate.get_node("CollisionShape2D").disabled = true
		bossGate.hide()
		get_tree().get_root().get_node("Game").get_node("Level").get_node("Boss1").queue_free()

# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity


func get_new_animation(is_shooting = false):
	var animation_new = ""
	if dead:
		animation_new = "death"
		return animation_new
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		elif Input.is_action_pressed("crouch"):
			animation_new = "crouch"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	if is_shooting:
		animation_new += "_weapon"
	return animation_new


func _on_PlatformTimer_timeout():
	set_collision_mask_bit(3, true)


func _on_DamageDetector_body_entered(body):
	print("collide")
	if body is Bullet:
		return
	print("Enemy Hits Player")
	take_damage(1)
	
func set_lever1():
	print("Lever 1 is active")
	lever1 = true
	all_levers()
	
func set_lever2():
	print("Lever 2 is active")
	lever2 = true
	all_levers()
	
func set_lever3():
	print("Lever 3 is active")
	lever3 = true
	all_levers()

func all_levers():
	if lever1 and lever2 and lever3:
		print("All levers active")
		if PlayerStats.sfx:
			$DoorOpen.play()
		door3.queue_free()
		door4.queue_free()
		if leverDialog:
			leverDialog.queue_free()

func enter_computer():
	interactIcon.show()
	atComputer = true

func exit_computer():
	interactIcon.hide()
	atComputer = false
	
func enter_final():
	interactIcon.show()
	atFinalConsole = true

func exit_final():
	interactIcon.hide()
	atFinalConsole = false
	
	
func enter_door():
	interactIcon.show()
	atDoor = true
	
func exit_door():
	interactIcon.hide()
	atDoor = false
	
func disable_invulnerable():
	invulnerable = false


func _on_DamageTimer_timeout():
	invulnerable = false


func _on_RespawnTimer_timeout():
	invulnerable = false
	respawn()
	
func _on_FadeInTimer_timeout():
	wake_up()
	
func _on_ComputerTimer_timeout():
	introduction()
	
func _on_SpikeDialog_body_entered(body):
	spikeDialog.queue_free()
	textBox.queue_text("I'm not made of adamantium, I better not touch those.")

func _on_EnemyDialog_body_entered(body):
	enemyDialog.queue_free()
	textBox.queue_text("Looks like I found those infected bots. Better be careful.")

func _on_LeverDialog_body_entered(body):
	leverDialog.queue_free()
	textBox.queue_text("Alex: \"Looks like these doors are controlled externally.\"")
	textBox.queue_text("Alex: \"There should be 3 levers somewhere else in the station.\"")


func _on_BossTrigger_body_entered(body):
	if canTriggerBoss:
		canTriggerBoss = false
		bossGate.get_node("CollisionShape2D").disabled = false
		bossGate.show()
		if bossSpawned:
			boss_retry()
		else:
			boss_introduction()
