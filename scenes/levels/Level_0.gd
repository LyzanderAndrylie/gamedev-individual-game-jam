extends Node2D

var boss_killed = false

@onready var health_bar = $CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/HealthBar
@onready var shoot_status = $"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Shoot Status"
@onready var skill_status = $"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Skill Status"
@onready var dash_status = $"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Dash Status"
@onready var death_count = $"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Death Count"
@onready var noir = $Noir
@onready var popup = $CanvasLayer/PopupPanel
@onready var next_level_barrier = $Barrier/NextLevelBarrier


func _ready():
	GameState.CurrentLevel = 0


func _process(delta):
	health_bar.value = noir.health
	shoot_status.button_pressed = noir.can_shot
	skill_status.button_pressed = noir.change_gravity_active
	dash_status.button_pressed = noir.dash_cooldown_timer.is_stopped()
	death_count.text = "Death Count: %s" % (GameState.deathCount)


func _on_challenge_body_entered(body):
	if body.name == "Noir" and not boss_killed and is_instance_valid(popup):
		popup.visible = true
		await get_tree().create_timer(4).timeout
		popup.visible = false


func boss_dead():
	next_level_barrier.queue_free()
	popup.queue_free()
	boss_killed = true


func _on_done_body_entered(body):
	if body.name == "Noir":
		GameState.CurrentLevel = 1
		get_tree().change_scene_to_file(
			"res://scenes/levels/Level_%d.tscn" % GameState.CurrentLevel
		)
