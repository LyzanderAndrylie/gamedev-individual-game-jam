extends Area2D


func _on_body_entered(body):
	if body.name == "Noir":
		GameState.deathCount += 1
		get_tree().change_scene_to_file("res://scenes/menus/GameOver.tscn")
	elif body.name == "Bullet":
		body.queue_free()
