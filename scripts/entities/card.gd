extends Panel

var card_active = false
var card_combinable = false
var card_already_used = false
var card_selected = false
var card_selectable_for_combine = false

var card_in_selected_series = 0

var card_owner : int
#var card_owner = [ # This is an array just in case I need to pull a string
	#"emptyspaceforreasons",
	#"player1",
	#"player2"
#]

var card_name = ""
var card_type = "no_type"
var card_area = ""
var target_area = ""
var power_level = 0

func _ready() -> void:
	TurnAndPhaseHandler.connect("main_phase_entered", set_card_usability)
	TurnAndPhaseHandler.connect("rally_phase_entered", set_card_usability)
	CardHandler.connect("card_used", set_card_usability)
	CardHandler.connect("card_used", use_selected_card)
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

func set_card_usability(selected = null):
	if selected == null:
		selected = false
	CardHandler.times_set_usability += 1
	#print("Checking card usability - ", CardHandler.times_set_usability)
	if card_name == "counter":
		if CardHandler.counter_card_in_effect == true:
			card_active = false
			modulate = Color8(20, 20, 20, 255)
			print("This card is the counter card")
			return
	
	
	if card_already_used == true:
		card_active = false
		modulate = Color8(20, 20, 20, 255)
		print("Card already used")
		return
	
	if selected == true:
		card_active = false
		modulate = Color8(20, 20, 20, 255)
		print("Card was previously selected")
		match card_owner:
			1:
				CardHandler.player_1_usable_cards.erase(card_type)
			2:
				CardHandler.player_2_usable_cards.erase(card_type)
		return
	card_active = check_card_usability(card_type)
	if card_already_used == false && card_active == true && selected == false:
		match card_type:
			"skill":
				match card_owner:
					1:
						if target_area == CardHandler.player_1_current_target || card_area == CardHandler.player_2_current_target || CardHandler.player_2_current_target == "" || TurnAndPhaseHandler.current_phase_index != 2:
							CardHandler.player_1_usable_cards.append(card_type)
						else:
							card_active = false
							print("no conditions satisfied")
							
					2:
						if target_area == CardHandler.player_2_current_target || card_area == CardHandler.player_1_current_target || CardHandler.player_1_current_target == "" || TurnAndPhaseHandler.current_phase_index != 2:
							CardHandler.player_2_usable_cards.append(card_type)
						else:
							card_active = false
							print("no conditions satisfied")
	else:
		if card_type == "skill":
			print("one of these picky bastards isnt satisfied")
			print("CAU: " +str(card_already_used), " CA: " +str(card_active), " selecting: " +str(selected))
			#"talent":
				#match card_owner:
					#1:
						#CardHandler.player_1_usable_cards.append(card_type)
					#2:
						#CardHandler.player_2_usable_cards.append(card_type)
	if card_type == "skill":
		if card_name == CardHandler.player_1_selected_card:
			card_selectable_for_combine = true
		elif card_name != CardHandler.player_1_selected_card: #TODO YOu know what to do
			card_selectable_for_combine = false
	else:
		card_selectable_for_combine = true
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
	#reset_card_usage()
	set_card_usability()
	if CardHandler.hide_player_2_cards == true && card_owner == 2:
		$HiddenCardBox.visible = true
	if card_type == "skill":
		card_selectable_for_combine = true
	
	match card_name:
		"net_shot", "drop_shot", "block":
			target_area = CardHandler.card_target_areas[0]
		"net_kill", "push", "drive", "smash":
			target_area = CardHandler.card_target_areas[1]
		"lift", "clear":
			target_area = CardHandler.card_target_areas[2]
	match card_name:
		"net_shot", "lift", "net_kill":
			card_area = CardHandler.card_target_areas[0]
		"block", "push", "drive":
			card_area = CardHandler.card_target_areas[1]
		"drop_shot", "clear", "smash":
			card_area = CardHandler.card_target_areas[2]
	$AREA.set_text(str(card_area))
	$TARGET.set_text(str(target_area))
	$POWER.set_text(str(power_level))

func use_card(selected_card = null): # Yup another hack, maybe I can get this to work with dictionaries
	if card_active != true:
		return
	if TurnAndPhaseHandler.player_in_turn != card_owner:
		print("It is not this card's owner's turn")
		return
	match card_type:
		"skill":
			print("Skill card used")
			CardHandler.anticipate_card_in_effect = false
			if card_selected == false:
				TurnAndPhaseHandler.emit_signal("player_changed_rally_status", card_owner, true)
			match card_owner:
				1:
					CardHandler.player_1_current_target = target_area
					CardHandler.player_1_current_power = power_level
				2:
					CardHandler.player_2_current_target = target_area
					CardHandler.player_2_current_power = power_level
				
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
								CardHandler.player_draw_new_card(card_owner, 1, blind_card)
					"deception":
						match card_owner:
							1:
								if CardHandler.player_1_selected_card_count == 0 || CardHandler.player_1_selected_card_count >= 2:
									print("Too many or no card selected")
									return
							2:
								if CardHandler.player_2_selected_card_count == 0 || CardHandler.player_2_selected_card_count >= 2:
									print("Too many or no card selected")
									return
						match card_owner:
							1:
								CardHandler.emit_signal("power_select_screen_activate", card_owner, true)
								while CardHandler.power_select_screen_visible_player_1 == true:
									await get_tree().create_timer(.1).timeout
								self.power_level = CardHandler.player_1_selected_card_power
								card_name = CardHandler.player_1_selected_card_traits[0]
								card_area = CardHandler.player_1_selected_card_traits[1]
								target_area = CardHandler.player_1_selected_card_traits[2]
							2:
								CardHandler.emit_signal("power_select_screen_activate", card_owner, true)
								while CardHandler.power_select_screen_visible_player_2 == true:
									await get_tree().create_timer(.1).timeout
								self.power_level = CardHandler.player_2_selected_card_power
								card_name = CardHandler.player_2_selected_card_traits[0]
								card_area = CardHandler.player_2_selected_card_traits[1]
								target_area = CardHandler.player_2_selected_card_traits[2]
					"anticipate":
						var random_number = randi_range(1, 2)
						print("random number: ", random_number)
						match card_owner:
							1:
								match random_number:
									1:
										CardHandler.player_2_current_target = ""
									2:
										pass
							2:
								match random_number:
									1:
										#TurnAndPhaseHandler.player_1_used_skill_card_count -= 1
										CardHandler.player_1_current_target == ""
									2:
										pass
						#CardHandler.anticipate_card_in_effect = true
					"counter":
						CardHandler.counter_card_in_effect = true
						print("COUNTER CARD USED BIATCH")
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
	#if card_in_selected_series == 0:
	 #CardHandler.anticipate_card_in_effect == false && 
	if CardHandler.counter_card_in_effect == true:
		print("Counter card still in effect")
		match card_owner:
			1:
				if CardHandler.player_2_card_use_buffer > 0:
					print("Weve somehow got here")
					if CardHandler.player_1_card_use_buffer >= CardHandler.player_2_card_use_buffer:
						CardHandler.counter_card_in_effect = false
			2:
				if CardHandler.player_1_card_use_buffer > 0:
					if CardHandler.player_2_card_use_buffer >= CardHandler.player_1_card_use_buffer:
						CardHandler.counter_card_in_effect = false
	if CardHandler.counter_card_in_effect == false:
		
		match card_owner:
			1:
				CardHandler.player_2_card_use_buffer = 0
				TurnAndPhaseHandler.emit_signal("player_turn_changed", 2)
				
				#CardHandler.player_1_usable_cards.erase(card_type)
			2:
				CardHandler.player_1_card_use_buffer = 0
				TurnAndPhaseHandler.emit_signal("player_turn_changed", 1)
		CardHandler.clear_player_usable_cards()
		#set_card_usability(false)
		CardHandler.emit_signal("card_used")
		card_already_used = true
		#CardHandler.cancel_card_in_effect = false
		print("Card area: ", card_area)
		print("Card Target", target_area)
		TurnAndPhaseHandler.check_for_rally_winner()
	elif CardHandler.counter_card_in_effect == true:
		card_already_used = true
		card_active = false
		modulate = Color8(20, 20, 20, 255)
		match card_owner:
			1:
				CardHandler.player_1_current_power += power_level
			2:
				CardHandler.player_2_current_power += power_level
		print("Card used in counter attack")
	match card_owner:
		1:
			CardHandler.player_1_card_use_buffer += 1
		2:
			CardHandler.player_2_card_use_buffer += 1
	
	

	#if CardHandler.counter_card_in_effect == true:
		#print("Counter card still in effect")
		#match card_owner:
			#1:
				#if CardHandler.player_2_card_use_buffer > 0:
					#print("Weve somehow got here")
					#if CardHandler.player_1_card_use_buffer >= CardHandler.player_2_card_use_buffer:
						#CardHandler.counter_card_in_effect = false
			#2:
				#if CardHandler.player_1_card_use_buffer > 0:
					#if CardHandler.player_2_card_use_buffer >= CardHandler.player_1_card_use_buffer:
						#CardHandler.counter_card_in_effect = false
func reset_card_usage():
	card_already_used = false


func use_selected_card():
	if card_selected == true:
		set_card_usability(true)
		match card_owner:
			1:
				CardHandler.player_1_card_use_buffer += 1
			2:
				CardHandler.player_2_card_use_buffer += 1

func select_card(status_override = null):
	card_selected = !card_selected
	if status_override != null:
		card_selected = status_override
	CardHandler.player_1_selected_card_traits.clear()
	match card_owner:
		1:
			match card_selected:
				true:
					CardHandler.player_1_current_power += power_level
					card_selected = true
					if card_type == "skill":
						CardHandler.player_1_selected_card = card_name
						CardHandler.player_1_selected_card_traits.append(card_name)
						CardHandler.player_1_selected_card_traits.append(card_area)
						CardHandler.player_1_selected_card_traits.append(target_area)
					CardHandler.player_1_selected_card_count += 1
					card_in_selected_series = CardHandler.player_1_selected_card_count
					self_modulate = Color8(0, 0, 255, 255)
					print("card selected! ", CardHandler.player_1_selected_card)
				false:
					CardHandler.player_1_current_power -= power_level
					card_selected = false
					CardHandler.player_1_selected_card_traits.clear()
					CardHandler.player_1_selected_card_count -= 1
					card_in_selected_series = 0
					self_modulate = Color8(255, 255, 255, 255)
					if CardHandler.player_1_selected_card_count == 0:
						CardHandler.player_1_selected_card = ""
					print("card unselected!")
				#CardHandler.emit_signal("card_selected", null, true)
	
			print("Player 1 cards power level: ", CardHandler.player_1_current_power)
		2:
			match card_selected:
				true:
					CardHandler.player_2_current_power += power_level
					card_selected = true
					if card_type == "skill":
						CardHandler.player_2_selected_card = card_name
						CardHandler.player_2_selected_card_traits.append(card_name)
						CardHandler.player_2_selected_card_traits.append(card_area)
						CardHandler.player_2_selected_card_traits.append(target_area)
					CardHandler.player_2_selected_card_count += 1
					card_in_selected_series = CardHandler.player_2_selected_card_count
					self_modulate = Color8(0, 0, 255, 255)
					print("card selected! ", CardHandler.player_2_selected_card)
				false:
					CardHandler.player_2_current_power -= power_level
					card_selected = false
					CardHandler.player_2_selected_card_traits.clear()
					CardHandler.player_2_selected_card_count -= 1
					card_in_selected_series = 0
					self_modulate = Color8(255, 255, 255, 255)
					if CardHandler.player_2_selected_card_count == 0:
						CardHandler.player_2_selected_card = ""
					print("card unselected!")
				#CardHandler.emit_signal("card_selected", null, true)
	
			print("Player 2 cards power level: ", CardHandler.player_2_current_power)

func _on_touch_screen_button_pressed() -> void:
	if Input.is_action_pressed("ui_select"):
		if CardHandler.player_1_selected_card == "" || CardHandler.player_1_selected_card == card_name || card_type != "skill":
			select_card()
			return
		else:
			print("This bitch unselectable!")
			return
		
	if card_active == true:
		use_card()
		
	elif card_active == false:
		print("Card unusable in current phase!")
