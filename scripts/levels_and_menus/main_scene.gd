extends Control

const RALLY_CHOICE_POPUP_PATH = preload("res://scenes/menus/rally_choice_popup.tscn")

func _ready() -> void:
	TurnAndPhaseHandler.connect("phase_changed", update_phase_label_text)
	CardHandler.player_draw_new_card(1, 6)
	CardHandler.player_draw_new_card(2, 6)
	TurnAndPhaseHandler.next_phase()
	
func _physics_process(delta: float) -> void:
	pass


func update_phase_label_text():
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	var new_text = TurnAndPhaseHandler.phases[TurnAndPhaseHandler.current_phase_index]
	$PHASELABEL.set_text(new_text +str(" phase"))
	$PHASELABEL2.set_text(new_text +str(" phase"))
	tween.tween_property($PHASELABEL, "visible_characters",20, 1)
	tween2.tween_property($PHASELABEL2, "visible_characters", 20, 1)


func _on_rally_choice_popup_zone_button_pressed() -> void:
	var new_rally_choice_popup = RALLY_CHOICE_POPUP_PATH.instantiate()
	get_parent().add_child(new_rally_choice_popup)
	new_rally_choice_popup.global_position = get_global_mouse_position()
