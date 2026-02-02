extends Control


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#TurnAndPhaseHandler.connect("phase_changed", queue_free)


#func _on_gui_input(event: InputEvent) -> void:
	#GameLogHandler.change_game_log_panel_visibility.emit(true)

func _on_game_log_panel_panel_pressed() -> void:
	GameLogHandler.change_game_log_panel_visibility.emit(true)
	GameLogHandler.add_card_used_to_game_log.emit()
	print("FUCK")
