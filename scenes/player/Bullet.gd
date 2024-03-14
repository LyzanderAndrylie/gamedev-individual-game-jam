extends CharacterBody2D

const SPEED = 300.0

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta):
	var collision = move_and_collide(velocity.normalized() * delta * SPEED)
	
	if collision:
		var colliderObj = collision.get_collider()
		
		if colliderObj.name == 'Barrier':
			queue_free()
		elif colliderObj.name == 'TileMap':
			queue_free()
