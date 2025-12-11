extends Node2D

"""...and God said, 'let there be the fiddy fiddy bot'"""

var active_status = true

func _ready() -> void:
	TurnAndPhaseHandler.connect("player_turn_changed", play)
 
func play(unused_parameter = null):
	if active_status == false:
		return
	var already_attempted_card_indexes = []
	while TurnAndPhaseHandler.player_in_turn == 2:
		if TurnAndPhaseHandler.player_in_turn != 2:
			return
		var random_number = randi_range(0, $"../CardHolder_Player2".get_child_count()) - 1
		if already_attempted_card_indexes.has(random_number) == false:
			if $"../CardHolder_Player2".get_child(random_number).card_type == "skill" && $"../CardHolder_Player2".get_child(random_number).card_active == true:
				$"../CardHolder_Player2".get_child(random_number).use_card()
				print("Player 2 AI using card: " +str($"../CardHolder_Player2".get_child(random_number)))
				already_attempted_card_indexes.append(random_number)
			else:
				pass
		else:
			pass
		print("P2AI Card used!")
		await get_tree().create_timer(.1).timeout
