extends CharacterBody2D

var bulletColor: String
var speed: float = 300.0
var animation_name: String

@onready var animation_sprite = $AnimatedSprite2D


func setup(animation_name_p: String, speed_p: int = speed):
	animation_name = animation_name_p
	bulletColor = animation_name
	speed = speed_p


func _ready():
	animation_sprite.play(animation_name)


func _physics_process(delta):
	var collision = move_and_collide(velocity.normalized() * delta * (speed))

	if collision:
		var colliderObj = collision.get_collider()

		if colliderObj.name == "Barrier" or colliderObj.name == "NextLevelBarrier":
			queue_free()
		elif colliderObj.name == "TileMap":
			queue_free()
