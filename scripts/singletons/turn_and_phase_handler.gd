extends Node

var player_1_card_holder
var player_2_card_holder

var previous_rally_winner = 0

var player_1_phase = ""
var player_2_phase = ""

var player_1_wants_to_rally = false
var player_2_wants_to_rally = false

var player_1_ready_for_next_phase = false
var player_2_ready_for_next_phase = false

var player_1_skill_card_count = 0
var player_2_skill_card_count = 0

var player_1_used_skill_card_count = 0
var player_2_used_skill_card_count = 0

var current_phase_index = 0

var player_in_turn = 1

var phases = [
	"draw",
	"main",
	"rally",
	"end"
]

@warning_ignore("unused_signal")
signal phase_changed # use with a string for the phase as the parameter
signal rally_phase_entered 
signal main_phase_entered
signal player_changed_rally_status # use with player number and bool for status
signal player_turn_changed

func _ready() -> void:
	connect("player_changed_rally_status", player_rally_status_tracker)
	connect("player_turn_changed", set_player_turn)

func next_phase():
	current_phase_index += 1
	if current_phase_index > 3:
		current_phase_index = 0
	phase_switch(phases[current_phase_index])

func phase_switch(new_phase:String):
	match new_phase:
		"draw":
			#CardHandler.reset_player_card_scenes(1)
			#CardHandler.reset_player_card_scenes(2)
			print("I GUESS WE DOIN DRAW PHASES NOW")
			CardHandler.player_draw_new_card(1, 1)
			CardHandler.player_draw_new_card(2, 1)
			next_phase()
			#CardHandler.player_draw_new_card(2, 1)
		"main":
			TurnAndPhaseHandler.emit_signal("main_phase_entered")
		"rally":
			current_phase_index = 2
			if player_1_wants_to_rally == true && player_2_wants_to_rally == true:
				print("Both players want to rally, good luck!")
				rally_phase_refactor()
			else:
				next_phase()
				print("One of the players chose to skip rally phase")
		"end": # TODO add points to whatever player didnt skip rally if applicable
			player_1_wants_to_rally = false
			player_2_wants_to_rally = false
			CardHandler.player_1_current_target = ""
			CardHandler.player_2_current_target = ""
			next_phase()
			CardHandler.clear_player_usable_cards()
	emit_signal("phase_changed")
	print("Current phase: ", new_phase)

func player_rally_status_tracker(player:int, new_status:bool):
	match player:
		1:
			if player_1_wants_to_rally == new_status:
				return
			player_1_wants_to_rally = new_status
		2:
			if player_2_wants_to_rally == new_status:
				return
			player_2_wants_to_rally = new_status
	if player_1_wants_to_rally == true && player_2_wants_to_rally == true:
		next_phase()
	elif player_1_wants_to_rally == true && player_2_wants_to_rally == false || player_1_wants_to_rally == false && player_2_wants_to_rally == true:
		print("Both players still arent ready for rally")
	
func reset_skill_card_counts():
	player_1_skill_card_count = 0
	player_2_skill_card_count = 0

func compare_integer_sizes(int_1:int, int_2:int):
	if int_1 > int_2:
		return 1
	elif int_1 < int_2:
		return 2

func rally_phase_refactor():
	
	print("player_1_usable_cards: ", CardHandler.player_1_usable_cards.size())
	print("player_2_usable_cards: ", CardHandler.player_2_usable_cards.size())
	emit_signal("rally_phase_entered")

#func rally_phase():
	##var player_1_skill_card_count = CardHandler.get_card_type_count(1, "skill")
	##var player_2_skill_card_count = CardHandler.get_card_type_count(2, "skill")
	#player_1_used_skill_card_count = 0
	#player_2_used_skill_card_count = 0
	#var rally_winner = 0 # Set to player number on their win
	#
	#print("player_1_usable_cards: ", CardHandler.player_1_usable_cards.size())
	#print("player_2_usable_cards: ", CardHandler.player_2_usable_cards.size())
	#emit_signal("rally_phase_entered")
	#
	#while rally_winner == 0:
		##print("checking if someones won. player 1 cards: " +str(CardHandler.player_1_usable_cards.count("skill")) +str(" player 2 cards: " +str(CardHandler.player_2_usable_cards.count("skill"))))
		##print("player 1 target: " +str(CardHandler.player_1_current_target))
		##print("player 2 target: " +str(CardHandler.player_2_current_target))
		##if player_1_used_skill_card_count == player_1_skill_card_count:
			##rally_winner = compare_integer_sizes(player_1_used_skill_card_count, player_2_used_skill_card_count)
		##elif player_2_used_skill_card_count == player_2_skill_card_count:
			##rally_winner = compare_integer_sizes(player_1_used_skill_card_count, player_2_used_skill_card_count)
		#rally_winner = check_for_rally_winner()
		#
		#
		#
		#
		#
		#await get_tree().create_timer(.1).timeout
	#
	#match rally_winner:
		#1:
			#ScoreHandler.player_1_score += 1
		#2:
			#ScoreHandler.player_2_score += 1
	#print("Player 1 score: ", ScoreHandler.player_1_score)
	#print("Player 2 score: ", ScoreHandler.player_2_score)
	##CardHandler.player_1_usable_cards = CardHandler.empty_array.duplicate()
	##CardHandler.player_1_usable_cards.erase("empty_space_:)")
	##CardHandler.player_2_usable_cards = CardHandler.empty_array.duplicate()
	##CardHandler.player_2_usable_cards.erase("empty_space_:)")
	#CardHandler.emit_signal("reset_card_usage")
	#next_phase()
	
	
func check_player_card_power_levels(player_to_check:int):
	var temporary_power_level_buffer : int
	match player_to_check:
		1:
			for n in player_1_card_holder.get_child_count():
				print("Checking player 1 card power level: " +str( player_1_card_holder.get_child(n)))
				if player_1_card_holder.get_child(n).power_level > CardHandler.player_2_current_power && player_1_card_holder.get_child(n).card_active == true:
					return true
				else:
					print("Card not powerful enough!")
			print("Player 1's cards arent high enough")
			return false
		2:
			for n in player_2_card_holder.get_child_count():
				print("Checking player 2 card power levels" +str( player_2_card_holder.get_child(n)))
				if player_2_card_holder.get_child(n).power_level > CardHandler.player_1_current_power && player_2_card_holder.get_child(n).card_active == true:
					return true
				else:
					print("Card not powerful enough!")
			print("Player 2's cards arent high enough")
			return false

func check_for_rally_winner():
	if current_phase_index != 2:
		print("IT AINT EVEN THE RALLY PHASE")
		return
	print("checking for rally winner")
	var rally_winner = 0
	#if current_phase_index == 2:
	if CardHandler.player_1_current_power > 0:
		if CardHandler.player_1_current_power < CardHandler.player_2_current_power && check_player_card_power_levels(1) == false:
			rally_winner = 2
		else:
			pass
	if CardHandler.player_2_current_power > 0:
		if CardHandler.player_2_current_power < CardHandler.player_1_current_power && check_player_card_power_levels(2) == false:
			rally_winner = 1
		else:
			pass
	if CardHandler.player_1_usable_cards.count("skill") == 0:
		rally_winner = 2
	elif CardHandler.player_2_usable_cards.count("skill") == 0:
		rally_winner = 1
	CardHandler.player_1_selected_card = ""
	CardHandler.player_2_selected_card = ""
	match rally_winner:
			1:
				ScoreHandler.player_1_score += 1
			2:
				ScoreHandler.player_2_score += 1
			0:
				print("No winner yet")
				return
	CardHandler.emit_signal("reset_card_usage")
	print("Player ", rally_winner, " won the rally")
	CardHandler.player_1_current_power = 0
	CardHandler.player_2_current_power = 0
	next_phase()
	previous_rally_winner = rally_winner

func set_global_phase(new_phase:String): # Not really for use regularly
	
	player_1_phase = new_phase
	player_2_phase = new_phase
	
func next_player_phase(player:int, new_phase:String):
	match player:
		1:
			player_1_phase = new_phase
		2:
			player_1_phase = new_phase

func set_player_turn(new_turn:int):
	player_in_turn = new_turn
