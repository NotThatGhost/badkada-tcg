extends Control

func _ready() -> void:
	#TurnAndPhaseHandler.phase_switch("draw")
	$CardHandler.player_draw_new_card(1, 12)
	TurnAndPhaseHandler.next_phase()
	

#func _physics_process(delta: float) -> void:
	#$CardHandlerNode.player_draw_new_card(1)
