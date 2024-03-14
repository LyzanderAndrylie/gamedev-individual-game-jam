extends Node2D


func _ready():
	GameState.CurrentLevel = 0

func _process(delta):
	$CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/HealthBar.value = $Noir.health
	$"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Shoot Status".button_pressed = $Noir.can_shot
	$"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Skill Status".button_pressed = $Noir.change_gravity_active
	$"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Dash Status".button_pressed  = $Noir.current_dash_cooldown_time == 0
	$"CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/Death Count".text = 'Death Count: %s' % (GameState.deathCount)
