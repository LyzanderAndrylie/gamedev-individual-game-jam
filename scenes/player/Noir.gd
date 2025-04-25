extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_MULTIPLIER = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Double jump
var jump_count = 0

# Dash
var right_dash_enable = false
var left_dash_enable = false

# Bullet
var bulletScene = preload("res://scenes/player/Bullet.tscn")

# Gravity
var default_gravity = 1
var gravity_change = false
var change_gravity_active = true

# Shoot
var can_shot = true

# Life
var health = 100

# Damage
var hitInfoScene = preload("res://scenes/misc/FloatingNumber.tscn")
var hitDamage = 20

# Cheat
var cheat_active = false
var last_health = health
var last_default_gravity = default_gravity

@onready var shoot_timer = $Timer/ShootTimer
@onready var change_gravity_timer = $Timer/ChangeGravityTimer
@onready var dash_active_timer = $Timer/DashActiveTimer
@onready var dash_cooldown_timer = $Timer/DashCooldownTimer

@onready var shoot_marker = $Shoot
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox_collision = $Hitbox/CollisionShape2D
@onready var player_collision = $CollisionShape2D

@onready var trail_particle = $GPUParticles2D
@onready var jump_audio = $Jump


func _physics_process(delta):
	handle_gravity(delta)
	handle_jump()
	handle_move()
	handle_dash()
	handle_shoot()
	set_animation()
	move_and_slide()
	handle_cheat()


func handle_gravity(delta):
	if Input.is_action_just_pressed("ui_gravity") and change_gravity_active:
		default_gravity = -default_gravity
		gravity_change = not gravity_change
		player_collision.position.y *= -1
		hitbox_collision.position.y *= -1
		trail_particle.position.y *= -1

		# Set cooldown for change gravity skill
		change_gravity_active = false
		change_gravity_timer.start()

	# Add the gravity.
	if not is_on_floor() or gravity_change:
		velocity.y += gravity * delta * default_gravity


func handle_jump():
	# Handle jump and double jump
	if (is_on_floor() and not gravity_change) or (is_on_ceiling() and gravity_change):
		jump_count = 0

	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or is_on_ceiling()):
		velocity.y = JUMP_VELOCITY * default_gravity
		jump_count = 1
		jump_audio.play()
	elif Input.is_action_just_pressed("ui_accept") and jump_count < 2:
		velocity.y = JUMP_VELOCITY * default_gravity
		jump_count = 2
		jump_audio.play()


func handle_move():
	if not cheat_active:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_accept", "ui_down")
		velocity = direction * SPEED if direction else Vector2.ZERO
		move_and_slide()


func handle_dash():
	if Input.is_action_just_released("ui_right") and dash_cooldown_timer.is_stopped():
		right_dash_enable = true
		left_dash_enable = false
		dash_active_timer.start()

	if Input.is_action_just_released("ui_left") and dash_cooldown_timer.is_stopped():
		left_dash_enable = true
		right_dash_enable = false
		dash_active_timer.start()

	if (
		Input.is_action_just_pressed("ui_right")
		and right_dash_enable
		and not dash_active_timer.is_stopped()
	):
		velocity.x += SPEED * DASH_MULTIPLIER
		right_dash_enable = false
		dash_cooldown_timer.start()

	if (
		Input.is_action_just_pressed("ui_left")
		and left_dash_enable
		and not dash_active_timer.is_stopped()
	):
		velocity.x -= SPEED * DASH_MULTIPLIER
		left_dash_enable = false
		dash_cooldown_timer.start()


func handle_shoot():
	if Input.is_action_just_pressed("ui_click") and can_shot:
		var bullet = bulletScene.instantiate()
		bullet.setup("white" if gravity_change else "black")
		get_parent().add_child(bullet)

		bullet.position = shoot_marker.global_position
		bullet.velocity = get_global_mouse_position() - bullet.position
		bullet.global_rotation = shoot_marker.global_rotation
		can_shot = false
		shoot_timer.start()


func set_animation():
	# Change direction
	if Input.is_action_pressed("ui_left"):
		animated_sprite.set_flip_h(not gravity_change)
		trail_particle.emitting = true
	elif Input.is_action_pressed("ui_right"):
		animated_sprite.set_flip_h(gravity_change)
		trail_particle.emitting = true
	else:
		trail_particle.emitting = false

	# set animation jump
	if Input.is_action_just_pressed("ui_accept"):
		animated_sprite.play("jump" if not gravity_change else "jump_invert")

	# Set idle animation
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		animated_sprite.play("walk" if not gravity_change else "walk_invert")
	else:
		animated_sprite.play("default" if not gravity_change else "default_invert")


func _on_change_gravity_timer_timeout():
	change_gravity_active = true


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.bulletColor == "purple":
			health -= hitDamage

			popup(hitDamage)

			# player dead
			if health <= 0:
				GameState.deathCount += 1
				get_tree().change_scene_to_file("res://scenes/menus/GameOver.tscn")


func _on_shoot_timer_timeout():
	can_shot = true


func popup(hitDamage: int):
	var damage = hitInfoScene.instantiate()
	damage.setup(hitDamage)
	damage.position = global_position

	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", global_position + _get_direction(), 0.75)

	get_tree().current_scene.add_child(damage)


func _get_direction():
	return Vector2(randf_range(-1, 1), -randf()) * 16


func handle_cheat():
	if not Input.is_action_just_pressed("cheat"):
		return

	if cheat_active:
		print("Cheat disable")
		cheat_active = false

		health = last_health
		default_gravity = last_default_gravity
	else:
		print("Cheat active")
		cheat_active = true

		last_health = health
		last_default_gravity = default_gravity

		# Infinite health
		health = 9223372036854775807  # Biggest value an int can store
		# Disable gravity
		default_gravity = 0
