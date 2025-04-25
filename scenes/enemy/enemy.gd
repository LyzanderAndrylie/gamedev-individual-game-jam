extends CharacterBody2D

@export var color = "black"
@export var health = 100
@export var initialSpeed = 300
@export var nextSpeed = 800

@onready var health_bar = $HealthBar
@onready var shoot_marker = $Marker2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer

signal dead

var bulletScene = preload("res://scenes/player/Bullet.tscn")
var hitInfoScene = preload("res://scenes/misc/FloatingNumber.tscn")

var player = null
var hitDamage = 10


func _ready():
	health_bar.value = health
	randomize()


func shoot():
	var bullet = bulletScene.instantiate()
	bullet.setup("purple", nextSpeed if health <= 50 else initialSpeed)
	bullet.global_position = shoot_marker.global_position
	bullet.velocity = player.global_position - shoot_marker.global_position

	get_parent().add_child(bullet)


func _on_detection_area_body_entered(body):
	if body.name == "Noir":
		player = body
		animated_sprite.play("attack_black" if color == "black" else "attack_white")
		shoot_timer.start()


func _on_detection_area_body_exited(body):
	if body.name == "Noir":
		animated_sprite.play("default_black" if color == "black" else "default_white")
		shoot_timer.stop()


func _on_timer_timeout():
	shoot()


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.bulletColor == "purple":
			return

		# black can obly take damage from white bullte and vice versa
		if body.bulletColor == "black" and color != "black":
			health -= hitDamage
			popup(hitDamage)
		elif body.bulletColor == "white" and color != "white":
			health -= hitDamage
			popup(hitDamage)

		health_bar.value = health

		# enemy dead
		if health <= 0:
			queue_free()
			dead.emit()


func popup(hitDamage: int):
	var damage = hitInfoScene.instantiate()
	damage.setup(hitDamage)
	damage.position = global_position

	var tween = get_tree().create_tween()
	tween.tween_property(damage, "position", global_position + _get_direction(), 0.75)

	get_tree().current_scene.add_child(damage)


func _get_direction():
	return Vector2(randf_range(-1, 1), -randf()) * 16
