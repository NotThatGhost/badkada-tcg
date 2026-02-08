extends Node

var player_1_score = 0
var player_2_score = 0

var winner_number = 000

func reset_player_scores():
	player_1_score = 0
	player_2_score = 0

func _physics_process(delta: float) -> void:
	#if player_1_score >= 3 || player_2_score >= 3:
		#get_tree().change_scene_to_file("res://scenes/menus/end_result_screen.tscn")
	if player_1_score >= 3:
		winner_number = 1
		get_tree().change_scene_to_file("res://scenes/menus/end_result_screen.tscn")
		reset_player_scores()
	elif player_2_score >= 3:
		winner_number = 2
		get_tree().change_scene_to_file("res://scenes/menus/end_result_screen.tscn")
		reset_player_scores()
