extends CharacterBody2D


@export var color = 'black'

var bulletScene = preload("res://scenes/player/Bullet.tscn")
var player = null
var health = 100

var initialSpeed = 300
var nextSpeed = 800

var hitInfoScene = preload("res://scenes/misc/FloatingNumber.tscn")
var hitDamage = 10

func _ready():
	$HealthBar.value = health
	randomize()

func shoot():
	var bullet = bulletScene.instantiate()
	bullet.setup('purple', nextSpeed if health <= 50 else initialSpeed)
	get_parent().add_child(bullet, 500)
	bullet.position = $Marker2D.global_position
	bullet.velocity = player.global_position - global_position
	bullet.velocity += Vector2(20, 20)
	

func _on_detection_area_body_entered(body):
	if body.name == 'Noir':
		player = body
		$AnimatedSprite2D.play('attack_black' if color == 'black' else 'attack_white')
		$ShootTimer.start()


func _on_detection_area_body_exited(body):
	if body.name == 'Noir':
		$AnimatedSprite2D.play('default_black' if color == 'black' else 'default_white')
		$ShootTimer.stop()


func _on_timer_timeout():
	shoot()


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.bulletColor == 'purple': return
		
		# black can obly take damage from white bullte and vice versa
		if body.bulletColor == 'black' and color != 'black':
			health -= hitDamage
			popup(hitDamage)
		elif body.bulletColor == 'white' and color != 'white':
			health -= hitDamage
			popup(hitDamage)
		
		$HealthBar.value = health
		
		# enemy dead
		if health <= 0:
			queue_free()

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
