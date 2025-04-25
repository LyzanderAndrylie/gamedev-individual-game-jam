extends Control

var next_slide = load("res://scenes/menus/Menu.tscn")
var slide_duration = 2

@onready var timer = $Timer
@onready var progress_bar = $MarginContainer/ProgressBar


func _ready():
	progress_bar.max_value = slide_duration
	timer.wait_time = slide_duration
	timer.start()


func _process(delta):
	progress_bar.value = timer.time_left


func _on_timer_timeout():
	get_tree().change_scene_to_packed(next_slide)
