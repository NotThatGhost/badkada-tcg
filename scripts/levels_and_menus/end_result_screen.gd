extends Control

func _ready() -> void:
	$RESULT.set_text("Player ", str(TurnAndPhaseHandler.previous_rally_winner), " has won!")
	CardHandler.reset_game()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
