extends Area2D


func _on_body_entered(body):
	if body.name == "Noir" and not body.gravity_change:
		if body.cheat_active:
			return
		GameState.deathCount += 1
		get_tree().change_scene_to_file("res://scenes/menus/GameOver.tscn")
