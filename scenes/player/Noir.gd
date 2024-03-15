extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_MULTIPLIER = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Double jump
var jump_count = 0

# Dash
const DASH_ACTIVE_TIME = 0.1
const DASH_COOLDOWN_TIME = 2
var current_dash_active_time = 0
var current_dash_cooldown_time = 0
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

func _ready():
	$AnimatedSprite2D.play('default')
	
func handle_shoot():
	if Input.is_action_just_pressed('ui_click') and can_shot:
		var bullet = bulletScene.instantiate()
		bullet.setup('white' if gravity_change else 'black')
		get_parent().add_child(bullet)
		
		bullet.position = $Node2D/Marker2D.global_position
		bullet.velocity = get_global_mouse_position() - bullet.position
		can_shot = false
		$ShootTimer.start()


func _physics_process(delta):
	# Handle gravity
	if Input.is_action_just_pressed('ui_gravity') and change_gravity_active:
		default_gravity = -default_gravity
		gravity_change = not gravity_change
		$CollisionShape2D.position.y *= -1
		$Hitbox.position.y *= -1
		
		# Set cooldown for change gravity skill
		change_gravity_active = false
		$ChangeGravityTimer.start()
	
	# Add the gravity.
	if not is_on_floor() or gravity_change:
		velocity.y += gravity * delta * default_gravity
	
	# Handle jump and double jump 
	if (is_on_floor() and not gravity_change) or (is_on_ceiling() and gravity_change):
		jump_count = 0
	
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or is_on_ceiling()):
		velocity.y = JUMP_VELOCITY * default_gravity
		jump_count = 1
	elif Input.is_action_just_pressed("ui_accept") and jump_count < 2:
		velocity.y = JUMP_VELOCITY * default_gravity
		jump_count = 2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle dash
	current_dash_active_time = (
		current_dash_active_time - delta
		if current_dash_active_time > 0
		else 0
	)
	current_dash_cooldown_time = (
		current_dash_cooldown_time - delta
		if current_dash_cooldown_time > 0
		else 0
	)

	if Input.is_action_just_released("ui_right") and current_dash_cooldown_time == 0:
		right_dash_enable = true
		left_dash_enable = false
		current_dash_active_time = DASH_ACTIVE_TIME

	if Input.is_action_just_released("ui_left") and current_dash_cooldown_time == 0:
		left_dash_enable = true
		right_dash_enable = false
		current_dash_active_time = DASH_ACTIVE_TIME

	if Input.is_action_just_pressed("ui_right") and right_dash_enable and current_dash_active_time > 0:
		velocity.x += SPEED * DASH_MULTIPLIER
		right_dash_enable = false
		current_dash_cooldown_time = DASH_COOLDOWN_TIME

	if Input.is_action_just_pressed("ui_left") and left_dash_enable and current_dash_active_time > 0:
		velocity.x -= SPEED * DASH_MULTIPLIER
		left_dash_enable = false
		current_dash_cooldown_time = DASH_COOLDOWN_TIME
		
	# Handle Shoot
	handle_shoot()
	
	# Set animation
	set_animation()
	move_and_slide()
	

func set_animation():
	# Change direction
	if Input.is_action_pressed('ui_left'):
		$AnimatedSprite2D.set_flip_h(not gravity_change)
	elif Input.is_action_pressed('ui_right'):
		$AnimatedSprite2D.set_flip_h(gravity_change)
		
	# set animation jump
	if Input.is_action_just_pressed('ui_accept'):
		$AnimatedSprite2D.play('jump' if not gravity_change else 'jump_invert')
		
	# Set idle animation
	if Input.is_action_pressed('ui_right') or Input.is_action_pressed('ui_left'):
		$AnimatedSprite2D.play('walk' if not gravity_change else 'walk_invert')
	else:
		$AnimatedSprite2D.play('default' if not gravity_change else 'default_invert')


func _on_change_gravity_timer_timeout():
	change_gravity_active = true


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.bulletColor == 'purple':
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
	tween.tween_property(damage,
						 "position",
						 global_position + _get_direction(),
						 0.75)
 
	get_tree().current_scene.add_child(damage)
 
func _get_direction():
	return Vector2(randf_range(-1,1), -randf()) * 16
