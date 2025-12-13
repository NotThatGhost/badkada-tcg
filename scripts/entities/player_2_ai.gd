extends Node2D

"""...and God said, 'let there be the fiddy fiddy bot'"""

var active_status = true
var temporary_power_level_buffer = 0
var temporary_highest_power_level_card_index = 0
var searching_for_power_advantage_card = false

func _ready() -> void:
	TurnAndPhaseHandler.connect("player_turn_changed", play)
 
func play(unused_parameter = null):
	await get_tree().create_timer(2).timeout
	if active_status == false:
		return
	var already_attempted_card_indexes = []
	while TurnAndPhaseHandler.player_in_turn == 2:
		
		if TurnAndPhaseHandler.player_in_turn != 2:
			print("ai turn over")
			return
		var random_number = randi_range(0, $"../CardHolder_Player2".get_child_count()) - 1
		var card_in_use =  $"../CardHolder_Player2".get_child(random_number)
		if already_attempted_card_indexes.has(random_number) == false:
			if card_in_use.card_active == true && card_in_use.card_area == CardHandler.player_1_current_target:
				if  card_in_use.card_type == "skill" && card_in_use.power_level >= CardHandler.player_1_current_power:
					print("ai_FUCK YEAH")
				else:
					if card_in_use.card_type == "skill":
						print("ai_LETS GET READY TO RUMBLE")
						$"../CardHolder_Player2".get_child(search_for_highest_power_level_card_available()).use_card()
						temporary_highest_power_level_card_index = 0
						temporary_power_level_buffer = 0
						print("Player 2 AI using card after power check: " +str($"../CardHolder_Player2".get_child(random_number)))
						return
					if card_in_use.card_type == "talent":
						match card_in_use.card_name:
							"intimidate1", "intimidate2":
								use_card(card_in_use, random_number)
							"deception1", "deception2", "deception3":
								deception_card_effect()
								use_card(card_in_use, random_number)
							"anticipate1", "anticipate2":
								use_card(card_in_use, random_number)
							"counter1", "counter2":
								use_card(card_in_use, random_number)
				use_card(card_in_use, random_number)
				return
			else:
				pass
		else:
			pass
		print("P2AI Card attempted!")
		already_attempted_card_indexes.append(random_number)

func use_card(card_in_use = null, random_number = null):
	card_in_use.use_card()
	print("Player 2 AI using card: " +str($"../CardHolder_Player2".get_child(random_number)))
	return

func deception_card_effect():
	var selected_card_found = false
	var already_attempted_card_indexes = []
	while selected_card_found == false:
		var random_number = randi_range(0, $"../CardHolder_Player2".get_child_count()) - 1
		var random_selected_card = $"../CardHolder_Player2".get_child(random_number)
		if already_attempted_card_indexes.has(random_number):
			if random_selected_card.card_active == true && random_selected_card.card_area == random_selected_card.player_1_current_target:
				selected_card_found = true
				random_selected_card.select_card()
			else:
				already_attempted_card_indexes.append(random_number)

func search_for_highest_power_level_card_available():
	for n in $"../CardHolder_Player2".get_child_count():
		print("ai_Checking card: " +str( $"../CardHolder_Player2".get_child(n)))
		if $"../CardHolder_Player2".get_child(n).power_level > temporary_power_level_buffer && $"../CardHolder_Player2".get_child(n).card_active == true:
			temporary_power_level_buffer = $"../CardHolder_Player2".get_child(n).power_level
			temporary_highest_power_level_card_index = n
			print("AI current power level: " +str(temporary_power_level_buffer))
	return temporary_highest_power_level_card_index
