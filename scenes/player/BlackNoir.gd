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
const DASH_COOLDOWN_TIME = 0.5
var current_dash_active_time = 0
var current_dash_cooldown_time = 0
var right_dash_enable = false
var left_dash_enable = false

func _ready():
	$AnimatedSprite2D.play('default')


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump and double jump 
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_count = 1
	elif Input.is_action_just_pressed("ui_accept") and jump_count < 2:
		velocity.y = JUMP_VELOCITY
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
	
	# Set animation
	set_animation()
	move_and_slide()
	

func set_animation():
		# Change direction
	if Input.is_action_pressed('ui_left'):
		$AnimatedSprite2D.set_flip_h(true)
	elif Input.is_action_pressed('ui_right'):
		$AnimatedSprite2D.set_flip_h(false)
		
	# set animation jump
	if Input.is_action_just_pressed('ui_accept'):
		$AnimatedSprite2D.play('jump')
		
	# Set idle animation
	if is_on_floor():
		if Input.is_action_pressed('ui_right') or Input.is_action_pressed('ui_left'):
			$AnimatedSprite2D.play('walk')
		else:
			$AnimatedSprite2D.play('default')
	
	
