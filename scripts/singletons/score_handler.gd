extends Node

var player_1_score = 0
var player_2_score = 0

func _physics_process(delta: float) -> void:
	if player_1_score >= 3 || player_2_score >= 3:
		get_tree().change_scene_to_file("res://scenes/menus/end_result_screen.tscn")
