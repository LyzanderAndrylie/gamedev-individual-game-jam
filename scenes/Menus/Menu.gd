extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$BlackNoir.play('default')
	$WhiteNoir.play('default')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	GameState.CurrentLevel = 0
	get_tree().change_scene_to_file("res://scenes/levels/Level_0.tscn")


func _on_Quit_pressed():
	get_tree().quit()
