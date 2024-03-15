extends CharacterBody2D

const SPEED = 300.0
var bulletColor
var custom_speed

func _ready():
	pass

func setup(animation_name: String, speed: int = 0):
	$AnimatedSprite2D.play(animation_name)
	bulletColor = animation_name
	custom_speed = speed

func _physics_process(delta):
	var collision = move_and_collide(velocity.normalized() * delta * (SPEED if custom_speed == 0 else custom_speed))
	
	if collision:
		var colliderObj = collision.get_collider()
		
		if colliderObj.name == 'Barrier' or colliderObj.name == 'NextLevelBarrier':
			queue_free()
		elif colliderObj.name == 'TileMap':
			queue_free()
