class_name Boss1
extends Actor


enum State {
	WALKING,
	DEAD,
	CHARGING,
	ATTACK,
	INVINCIBLE
}

var _state = State.WALKING

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var attack_timer = $AttackTimer
onready var shield = $Shield

onready var healthbar = get_tree().get_root().get_node("Game").get_node("Level").get_node("BossHealth").get_node("ProgressBar")

onready var laser

onready var ded = false

onready var spawned = false
onready var phase4 = false
onready var phase12 = false

onready var health = 20
onready var direction = "right"
onready var tempVelocity
onready var moving = true


func _ready():
	speed = Vector2(100.0, 350.0)
	_velocity.x = speed.x
	attack_timer.start()
	shield.hide()

func _physics_process(_delta):
	
	healthbar.value = health
	
	if health <= 0:
		if _state == State.ATTACK:
			get_node("LaserBeam").queue_free()
		animation_player.play("destroy")
		$DeathTimer.start()
		if not ded:
			ded = true
			PlayerStats.enemies += 1
			get_tree().get_root().get_node("Game").get_node("Level").get_node("Interactibles").get_node("Console2").canCollide = true
			get_tree().get_root().get_node("Game").get_node("Level").get_node("Player").boss_kill()
	
	if health == 4 and not phase4:
		phase4 = true
		if _state == State.ATTACK:
			despawn_laser()
		_state = State.INVINCIBLE
		shield.show()
		if not spawned:
			spawn_laser_drone()
			spawned = true
			
	if health == 12  and not phase12:
		phase12 = true
		if _state == State.ATTACK:
			despawn_laser()
		_state = State.INVINCIBLE
		shield.show()
		if not spawned:
			spawn_laser_drone()
			spawned = true
		
	
	if _state == State.CHARGING or _state == State.ATTACK or _state == State.INVINCIBLE:
		tempVelocity = _velocity.x
		_velocity.x = 0
		var animation = get_new_animation()
		if animation != animation_player.current_animation:
			animation_player.play(animation)
		return
	elif _velocity.x == 0 and not _state == State.DEAD:
		_velocity.x = speed.x * sprite.scale.x
		
	
	
	# If the enemy encounters a wall or an edge, the horizontal velocity is flipped.
	if not floor_detector_left.is_colliding() and not _state == State.DEAD:
		_velocity.x = speed.x
		direction = "right"
	elif not floor_detector_right.is_colliding() and not _state == State.DEAD:
		_velocity.x = -speed.x
		direction = "left"

	if is_on_wall():
		_velocity.x *= -1
		if direction == "right":
			direction = "left"
		elif direction == "left":
			direction = "right"

	# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

	# We flip the Sprite depending on which way the enemy is moving.
	if _velocity.x > 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1

	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)

func take_damage():
	health -= 1
	if health <= 0:
		destroy()

func destroy():
	despawn_laser()
	if PlayerStats.sfx:
		$Hit.play()
	_velocity.x = 0
	_state = State.DEAD
	_velocity = Vector2.ZERO
	
func PlayExplosion():
	if PlayerStats.sfx:
		$Explode.play()
	
func spawn_laser_drone():
	var drone1 = load("res://src/Actors/LaserDrone1.tscn").instance()
	get_tree().get_root().get_node("Game").get_node("Level").add_child(drone1)
	

func get_new_animation():
	var animation_new = ""
	if _state == State.WALKING:
		$Laser.stop()
		animation_new = "walk"
	elif _state == State.CHARGING:
		$Laser.stop()
		animation_new = "charge"
	elif _state == State.ATTACK:
		animation_new = "attack"
	elif _state == State.DEAD:
		$Laser.stop()
		animation_new = "destroy"
	elif _state == State.INVINCIBLE:
		$Laser.stop()
		animation_new = "idle"
	return animation_new


func _on_AttackTimer_timeout():
	if _state == State.INVINCIBLE:
		return
	_state = State.CHARGING
	print("start charging")
	
func start_attack():
	print("attack")
	spawn_laser()
	if PlayerStats.sfx:
		$Laser.play()
	_state = State.ATTACK
	
	
func spawn_laser():
	print("spawn laser")
	laser = load("res://src/Actors/LaserBeam.tscn").instance()
	add_child(laser)
	if sprite.scale.x == -1:
		pass
		#laser.set_global_rotation(deg2rad(180))
		laser.set_global_position(Vector2(position.x - 500, position.y))
	
func despawn_laser():
	print("despawn laser")
	$Laser.stop()
	get_node("LaserBeam").queue_free()
	_state = State.WALKING
	attack_timer.start()
	
func end_lasers():
	spawned = false
	$Laser.stop()
	shield.hide()
	_state = State.WALKING
	attack_timer.start()
	


func _on_DeathTimer_timeout():
	$Laser.stop()
	get_tree().get_root().get_node("Game").get_node("Level").get_node("Player").boss_kill()
