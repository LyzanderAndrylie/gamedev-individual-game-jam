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
const CHANGE_GRAVITY_COOLDOWN_TIME = 2
var current_gravity_cooldown_time = 0

func _ready():
	$AnimatedSprite2D.play('default')

func handle_shoot():
	if Input.is_action_just_pressed('ui_click'):
		var bullet = bulletScene.instantiate()
		get_parent().add_child(bullet)
		bullet.position = $Node2D/Marker2D.global_position
		bullet.velocity = get_global_mouse_position() - bullet.position

func _physics_process(delta):
	# Handle gravity
	current_gravity_cooldown_time = (
		current_gravity_cooldown_time - delta
		if current_gravity_cooldown_time > 0
		else 0
	)
	
	if Input.is_action_just_pressed('ui_gravity') and current_gravity_cooldown_time == 0:
		default_gravity = -default_gravity
		gravity_change = not gravity_change
		$CollisionShape2D.position.y *= -1
		current_gravity_cooldown_time = CHANGE_GRAVITY_COOLDOWN_TIME
	
	# Add the gravity.
	if not is_on_floor() or gravity_change:
		velocity.y += gravity * delta * default_gravity
	
	# Handle jump and double jump 
	if is_on_floor() or is_on_ceiling():
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
	$Node2D.look_at(get_global_mouse_position())
	
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
	
	
