extends Panel

var card_active = false
var card_combinable = false
var card_already_used = false
var card_selected = false
var card_selectable_for_combine = false

var card_owner : int
#var card_owner = [ # This is an array just in case I need to pull a string
	#"emptyspaceforreasons",
	#"player1",
	#"player2"
#]

var card_name = ""
var card_type = "no_type"
var card_area = ""
var taget_area = ""
var power_level = 0

func _ready() -> void:
	TurnAndPhaseHandler.connect("phase_changed", set_card_usability)
	CardHandler.connect("card_used", set_card_usability)
	CardHandler.connect("card_selected", set_card_usability)
	CardHandler.connect("reset_card_usage", reset_card_usage)
	intitialize_card()

func check_card_usability(type_of_card:String):
# Yeah this ones a bit fucky but it should work and I have a deadline
	match type_of_card:
		"support":
			if TurnAndPhaseHandler.current_phase_index == 1:
				return true
			else:
				return false
		"skill":
			if TurnAndPhaseHandler.current_phase_index == 1 || TurnAndPhaseHandler.current_phase_index == 2:
				return true
			else:
				return false
		"talent":
			if TurnAndPhaseHandler.current_phase_index == 2:
				return true
			else:
				return false
		"event":
			if TurnAndPhaseHandler.current_phase_index == 1 || TurnAndPhaseHandler.current_phase_index == 2:
				return true
			else:
				return false
	#match card_owner:
		#1:
			#if card_area != CardHandler.player_2_current_target:
				#return false
		#2:
			#if card_area != CardHandler.player_1_current_target:
				#return false

func set_card_usability(new_status=null):
	if card_already_used == true:
		card_active = false
		modulate = Color8(20, 20, 20, 255)
		return
	card_active = check_card_usability(card_type)
	if new_status != null:
		card_active = new_status
	else:
		pass
	if TurnAndPhaseHandler.current_phase_index == 2:
		match card_owner:
			1:
				if card_area != CardHandler.player_2_current_target:
					card_active = false
					
			2:
				if card_area != CardHandler.player_1_current_target:
					card_active = false
	if card_name == CardHandler.player_1_selected_card:
		card_selectable_for_combine = true
	elif card_name != CardHandler.player_1_selected_card:
		card_selectable_for_combine = false
	#print("Card name: ", card_name)
	#print("Player 1 selected card: ", CardHandler.player_1_selected_card)

	
	
	if TurnAndPhaseHandler.player_in_turn == card_owner:
		if card_active == true:
			modulate = Color8(255, 255, 255, 255)
		elif card_active == false:
			modulate = Color8(20, 20, 20, 255)
	else:
		modulate = Color8(255, 0, 0, 255)


func intitialize_card():
	$CARDNAME.set_text(card_name)
	$CARDTYPE.set_text(card_type)
	set_card_usability()
	if CardHandler.hide_player_2_cards == true && card_owner == 2:
		$HiddenCardBox.visible = true
	if card_type == "skill":
		card_selectable_for_combine = true
	
	match card_name:
		"net_shot", "drop_shot", "block":
			taget_area = CardHandler.card_target_areas[0]
		"net_kill", "push", "drive", "smash":
			taget_area = CardHandler.card_target_areas[1]
		"lift", "clear":
			taget_area = CardHandler.card_target_areas[2]
	match card_name:
		"net_shot", "lift", "net_kill":
			card_area = CardHandler.card_target_areas[0]
		"block", "push", "drive":
			card_area = CardHandler.card_target_areas[1]
		"drop_shot", "clear", "smash":
			card_area = CardHandler.card_target_areas[2]
	$AREA.set_text(str(card_area))
	$TARGET.set_text(str(taget_area))
	$POWER.set_text(str(power_level))

func use_card(): # Yup another hack, maybe I can get this to work with dictionaries
	if TurnAndPhaseHandler.player_in_turn != card_owner:
		print("It is not this card's owner's turn")
		return
	match card_type:
		"skill":
			print("Skill card used")
			TurnAndPhaseHandler.emit_signal("player_changed_rally_status", card_owner, true)
			match card_owner:
				1:
					TurnAndPhaseHandler.player_1_used_skill_card_count += 1
					CardHandler.player_1_current_target = taget_area
				2:
					TurnAndPhaseHandler.player_2_used_skill_card_count += 1
					CardHandler.player_2_current_target = taget_area
			
			
			match card_name:
				"net_shot":
					pass
				"lift":
					pass
				"net_kill":
					pass
				"block":
					pass
				"push":
					pass
				"drive":
					pass
				"drop_shot":
					pass
				"clear":
					pass
				"smash":
					pass
		"talent":
			if CardHandler.cancel_card_in_effect == false:
				match card_name:
					"intimidate":
						match card_owner:
							1:
								var blind_card = CardHandler.player_2_cards.pick_random()
								CardHandler.player_1_cards.append(blind_card)
								CardHandler.player_2_cards.erase(blind_card)
								CardHandler.emit_signal("player_remove_card", 2, blind_card)
								CardHandler.player_draw_new_card(card_owner, 1, blind_card)
							2:
								var blind_card = CardHandler.player_1_cards.pick_random()
								CardHandler.player_2_cards.append(blind_card)
								CardHandler.player_1_cards.erase(blind_card)
								CardHandler.emit_signal("player_remove_card", 1, blind_card)
								CardHandler.player_draw_new_card(card_owner, 2, blind_card)
					"deception":
						pass
					"anticipate":
						var random_number = randi_range(1, 2)
						print("random number: ", random_number)
						match card_name:
							1:
								match random_number:
									1:
										TurnAndPhaseHandler.player_2_used_skill_card_count -= 1
									2:
										pass
							2:
								match random_number:
									1:
										TurnAndPhaseHandler.player_1_used_skill_card_count -= 1
									2:
										pass
					"counter":
						match card_owner:
							1:
								var amount_difference = TurnAndPhaseHandler.player_1_used_skill_card_count - TurnAndPhaseHandler.player_2_used_skill_card_count
								TurnAndPhaseHandler.player_1_used_skill_card_count = TurnAndPhaseHandler.player_2_used_skill_card_count
								TurnAndPhaseHandler.player_1_used_skill_card_count += amount_difference
							2:
								var amount_difference = TurnAndPhaseHandler.player_2_used_skill_card_count - TurnAndPhaseHandler.player_1_used_skill_card_count
								TurnAndPhaseHandler.player_2_used_skill_card_count = TurnAndPhaseHandler.player_1_used_skill_card_count
								TurnAndPhaseHandler.player_2_used_skill_card_count += amount_difference
			elif CardHandler.cancel_card_in_effect == true:
				CardHandler.cancel_card_in_effect = false
				print("Card canceled!")
		"support":
			if CardHandler.cancel_card_in_effect == false:
				match card_name:
					"reversal": #TODO figure out how to decouple from card
						CardHandler.reversal_card_effect()
					"break":
						CardHandler.player_draw_new_card(card_owner, 2)
			elif CardHandler.cancel_card_in_effect == true:
				print("card canceled!")
				CardHandler.cancel_card_in_effect = false
						
		"event":
			match card_name:
				"cancel":
					pass
	match card_owner:
		1:
			TurnAndPhaseHandler.emit_signal("player_turn_changed", 2)
		2:
			TurnAndPhaseHandler.emit_signal("player_turn_changed", 1)
	
	CardHandler.emit_signal("card_used")
	set_card_usability(false)
	card_already_used = true
	print("Card area: ", card_area)
	print("Card Target", taget_area)
	
func reset_card_usage():
	card_already_used = false

func select_card(status_override = null):
	card_selected = !card_selected
	if status_override != null:
		card_selected = status_override
	match card_selected:
		true:
			CardHandler.player_1_current_power += power_level
			card_selected = true
			CardHandler.player_1_selected_card = card_name
			CardHandler.player_1_selected_card_count += 1
			self_modulate = Color8(0, 0, 255, 255)
			print("card selected! ", CardHandler.player_1_selected_card)
		false:
			CardHandler.player_1_current_power -= power_level
			card_selected = false
			CardHandler.player_1_selected_card_count -= 1
			
			self_modulate = Color8(255, 255, 255, 255)
			if CardHandler.player_1_selected_card_count == 0:
				CardHandler.player_1_selected_card = ""
			print("card unselected!")
	CardHandler.emit_signal("card_selected")
	print("Player 1 cards power level: ", CardHandler.player_1_current_power)

func _on_touch_screen_button_pressed() -> void:
	if Input.is_action_pressed("ui_select"):
		if CardHandler.player_1_selected_card == "" || CardHandler.player_1_selected_card == card_name:
			select_card()
			return
		else:
			print("This bitch unselectable!")
			return
		
	if card_active == true:
		use_card()
	elif card_active == false:
		print("Card unusable in current phase!")
