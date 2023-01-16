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

onready var health = 3
onready var dead = false


func _ready():
	# Static types are necessary here to avoid warnings.
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
	
	if dead:
		return
	
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
	if Input.is_action_just_pressed("shoot" + action_suffix):
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

func get_direction(falling):
	return Vector2(
		Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix),
		-1 if is_on_floor() and !falling and Input.is_action_just_pressed("jump" + action_suffix) else 0
	)


func take_damage(damage):
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
	
	
