extends Control


func _on_draw_phase_debug_button_pressed() -> void:
	TurnAndPhaseHandler.set_global_phase("draw")
