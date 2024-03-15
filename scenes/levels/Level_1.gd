extends Node2D

const TOTAL_BOSS = 2
var total_boss_killed = 0

func _ready():
	GameState.CurrentLevel = 1

func _process(delta):
	$CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/HealthBar.value = $Noir.health
	$"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Shoot Status".button_pressed = $Noir.can_shot
	$"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Skill Status".button_pressed = $Noir.change_gravity_active
	$"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Dash Status".button_pressed  = $Noir.current_dash_cooldown_time == 0
	$"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Death Count".text = 'Death Count: %s' % (GameState.deathCount)


func _on_challenge_body_entered(body):
	if body.name == 'Noir':
		$CanvasLayer/PopupPanel.visible = true
		await get_tree().create_timer(4).timeout
		$CanvasLayer/PopupPanel.visible = false


func _on_enemy_tree_exited():
	if total_boss_killed == TOTAL_BOSS:
		$NextLevelBarrier.queue_free()
		$CanvasLayer/PopupPanel.queue_free()
	else:
		total_boss_killed += 1


func _on_done_body_entered(body):
	if body.name == 'Noir':
		get_tree().change_scene_to_file("res://scenes/menus/Win.tscn")
