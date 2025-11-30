extends Control



func _on_accept_button_pressed() -> void:
	TurnAndPhaseHandler.player_1_wants_to_rally = true
	queue_free()

func _on_decline_button_pressed() -> void:
	TurnAndPhaseHandler.emit_signal("player_changed_rally_status", 1 , false)
	#TurnAndPhaseHandler.player_1_wants_to_rally = false
	queue_free()
