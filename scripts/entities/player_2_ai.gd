extends Node2D

"""...and God said, 'let there be the fiddy fiddy bot'"""

var active_status = true
var temporary_power_level_buffer = 0
var temporary_highest_power_level_card_index = 0
var searching_for_power_advantage_card = false

func _ready() -> void:
	TurnAndPhaseHandler.connect("player_turn_changed", play)
 
func play(unused_parameter = null):
	await get_tree().create_timer(.5).timeout
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
			if card_in_use.card_type != "talent" && card_in_use.card_active == true && card_in_use.card_area == CardHandler.player_1_current_target:
				if card_in_use.card_type == "skill" && card_in_use.power_level >= CardHandler.player_1_current_power:
					print("ai_FUCK YEAH")
				else:
					if card_in_use.card_type == "skill":
						print("ai_LETS GET READY TO RUMBLE")
						$"../CardHolder_Player2".get_child(search_for_highest_power_level_card_available()).use_card()
						temporary_highest_power_level_card_index = 0
						temporary_power_level_buffer = 0
				card_in_use.use_card()
				print("Player 2 AI using card: " +str($"../CardHolder_Player2".get_child(random_number)))
				already_attempted_card_indexes.append(random_number)
			else:
				pass
		else:
			pass
		print("P2AI Card used!")
		

func search_for_highest_power_level_card_available():
	for n in $"../CardHolder_Player2".get_child_count():
		print("ai_Checking card: " +str( $"../CardHolder_Player2".get_child(n)))
		if $"../CardHolder_Player2".get_child(n).power_level > temporary_power_level_buffer && $"../CardHolder_Player2".get_child(n).card_active == true:
			temporary_power_level_buffer = $"../CardHolder_Player2".get_child(n).power_level
			temporary_highest_power_level_card_index = n
			print("AI current power level: " +str(temporary_power_level_buffer))
	return temporary_highest_power_level_card_index
