extends Control


func _ready() -> void:
	CardHandler.add_card_to_grid.connect(delete_card_indicator)
	TurnAndPhaseHandler.show_game_score.connect(queue_free)


#func _on_gui_input(event: InputEvent) -> void:
	#GameLogHandler.change_game_log_panel_visibility.emit(true)

func _on_game_log_panel_panel_pressed() -> void:
	GameLogHandler.change_game_log_panel_visibility.emit(true)
	GameLogHandler.add_card_used_to_game_log.emit()
	print("FUCK")

# Yeah I know its fucked
func delete_card_indicator(unused_parameter = null, another_unused_parameter = null):
	await get_tree().create_timer(.3).timeout
	queue_free()
