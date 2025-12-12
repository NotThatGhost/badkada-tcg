extends Control

const RALLY_CHOICE_POPUP_PATH = preload("res://scenes/menus/rally_choice_popup.tscn")

func _ready() -> void:
	TurnAndPhaseHandler.player_1_card_holder = $PlayArea_Player1/HScrollBar/CardHolder_Player1
	TurnAndPhaseHandler.player_2_card_holder = $PlayArea_Player2/HScrollBar/CardHolder_Player2
	update_phase_label_text()
	$DeckIcon/DECKSIZECOUNT.set_text(str(CardHandler.game_use_deck.size()))
	TurnAndPhaseHandler.connect("phase_changed", update_phase_label_text)
	CardHandler.connect("power_select_screen_activate", activate_power_select_popup)
	await get_tree().create_timer(1).timeout
	$MainAnimationPlayer.play("beginning_draw_animation")
	await $MainAnimationPlayer.animation_finished
	TurnAndPhaseHandler.next_phase()
	#CardHandler.player_draw_new_card(1, 12)
	#CardHandler.player_draw_new_card(2, 12)
	#CardHandler.player_draw_new_card(1, 1, null, "deception1")
	
	
	#CardHandler.player_draw_new_card(1, 1, "reversal")
	
func _physics_process(delta: float) -> void:
	pass

func main_scene_draw_card(player:int, amount: int):
	CardHandler.player_draw_new_card(player, amount)
	$DeckIcon/DECKSIZECOUNT.set_text(str(CardHandler.game_use_deck.size()))

func update_phase_label_text():
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	var new_text = TurnAndPhaseHandler.phases[TurnAndPhaseHandler.current_phase_index]
	$SCORELABEL.set_text("Score: " +str(ScoreHandler.player_1_score) +str(" - ") +str(ScoreHandler.player_2_score))
	$PHASELABEL.set_text(new_text +str(" phase"))
	$PHASELABEL2.set_text(new_text +str(" phase"))
	tween.tween_property($PHASELABEL, "visible_characters",20, 1)
	tween2.tween_property($PHASELABEL2, "visible_characters", 20, 1)


func activate_power_select_popup(player:int, new_status:bool):
	match player:
		1:
			$Player1DeceptionPanel.visible = new_status
			CardHandler.power_select_screen_visible_player_1 = new_status
		2:
			pass
			

func _on_rally_choice_popup_zone_button_pressed() -> void:
	var new_rally_choice_popup = RALLY_CHOICE_POPUP_PATH.instantiate()
	get_parent().add_child(new_rally_choice_popup)
	new_rally_choice_popup.global_position = get_global_mouse_position()


func player_1_power_button_function(selected_power:int):
	CardHandler.player_1_selected_card_power = selected_power
	$Player1DeceptionPanel.visible = false
	CardHandler.power_select_screen_visible_player_1 = false

func _on_strength_button_1_pressed() -> void:
	player_1_power_button_function(1)


func _on_strength_button_2_pressed() -> void:
	player_1_power_button_function(2)


func _on_strength_button_3_pressed() -> void:
	player_1_power_button_function(3)
