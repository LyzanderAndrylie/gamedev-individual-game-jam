extends Control


func _on_Start_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/Level_0.tscn")


func _on_Quit_pressed():
	get_tree().quit()
