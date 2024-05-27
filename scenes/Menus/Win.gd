extends Control

@onready var death_count_label = $MarginContainer/VBoxContainer/DeathCount


func _ready():
	death_count_label.text = "Death Count: %d" % GameState.deathCount


func _on_quit_pressed():
	get_tree().quit()


func _on_home_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/Menu.tscn")
