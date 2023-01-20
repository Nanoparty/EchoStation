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

onready var health = 3
onready var dead = false
onready var jumpCount = 0
onready var canDoubleJump = true
onready var canShoot = true

onready var canMove = true

onready var key1 = false
onready var key2 = false
onready var key3 = false

onready var lever1 = false
onready var lever2 = false
onready var lever3 = false

onready var invulnerable = false

onready var atComputer = false
onready var atDoor = false


func _ready():
	# Static types are necessary here to avoid warnings.
	
	key1Icon.hide()
	key2Icon.hide()
	key3Icon.hide()
	
	interactIcon.hide()
	
	var camera: Camera2D = $Camera
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
		yield(get_tree(), "idle_frame")
		camera.make_current()
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport2"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport
		yield(get_tree(), "idle_frame")
		camera.make_current()


# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	
	if dead or textBox.pause:
		return
		
	update_keys()
	
	if Input.is_action_just_pressed("ui_accept") && atComputer:
		introduction()
		
	if Input.is_action_just_pressed("ui_accept") && atDoor:
		door_locked()
	
	var falling = false
	# Fall through platforms
	if Input.is_action_pressed("crouch" + action_suffix) and Input.is_action_just_pressed("jump" + action_suffix) and is_on_floor():
		set_collision_mask_bit(3, false)
		falling = true
		get_node("PlatformTimer").start()
	# Play jump sound
	elif Input.is_action_just_pressed("jump" + action_suffix) and is_on_floor(): 
		sound_jump.play()
		
	var direction = get_direction(falling)

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
	textBox.queue_text("Ugh...my servos feel so rusty. Where am I?")
	textBox.queue_text("It looks like the station, but something feels wrong here...")
	textBox.queue_text("I better go find out whats happening around here.")
	
func introduction():
	textBox.queue_text("Welcome! I'm A.L.E.X.")
	
func door_locked():
	textBox.queue_text("This door is locked.")
		
func set_canDoubleJump():
	canDoubleJump = true
	textBox.queue_text("Look at this! My old maneuvering thrusters!")
	textBox.queue_text("With these I should be able to get around a lot easier.")
	
func set_canShoot():
	canShoot = true
	textBox.queue_text("Hey! Its my old plasma cutter arm!")
	textBox.queue_text("Now I should be able to defend myself against those rogue machines.")
	
func pickup_Key1():
	key1 = true
	textBox.queue_text("This looks like the first security key!")
	textBox.queue_text("I better give this to A.L.E.X so she can unlock the station controls.")
	
func pickup_Key2():
	key2 = true
	textBox.queue_text("Nice, the second security key!")
	textBox.queue_text("Just one more to go.")
	
func pickup_Key3():
	key3 = true
	textBox.queue_text("The last security key!")
	textBox.queue_text("Now A.L.E.X should be able to fix the station.")
	textBox.queue_text("I can't wait for things to return to normal.")

func get_direction(falling):
	var UpVector = 0
	
	if is_on_floor() and !falling:
		jumpCount = 0

	
	if jumpCount < 2 and !is_on_floor() and Input.is_action_just_pressed("jump" + action_suffix) and canDoubleJump:
		UpVector = -1
		jumpCount = 2
		sound_jump.play()

	elif jumpCount == 0 and is_on_floor() and !falling and Input.is_action_just_pressed("jump" + action_suffix):
		UpVector = -1
		jumpCount += 1

		
	return Vector2(
		Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix),
		UpVector
	)


func take_damage(damage):
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
		$Hit.play(0)
	else:
		$Explode.play(0)
		set_animation("death")
		dead = true
		invulnerable = true
		$RespawnTimer.start()
		
func respawn():
	var respawnPoint = get_tree().get_root().get_children()[0].get_node("Level").get_node("PlayerSpawn")
	transform = respawnPoint.transform
	health = 3
	hpBar.frame = 3
	dead = false

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
	#if body is Spike:
		#print("Spike Hits Player")
		#take_damage(1)
	
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
		get_tree().get_root().get_children()[0].get_node("Level").get_node("Doors").get_node("Door3").queue_free()
		get_tree().get_root().get_children()[0].get_node("Level").get_node("Doors").get_node("Door4").queue_free()

func enter_computer():
	interactIcon.show()
	atComputer = true

func exit_computer():
	interactIcon.hide()
	atComputer = false
	
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
