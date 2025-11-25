extends Node

var player_1_phase = ""
var player_2_phase = ""

var player_1_wants_to_rally = false
var player_2_wants_to_rally = false

var player_1_ready_for_next_phase = false
var player_2_ready_for_next_phase = false

var current_phase_index = 0

var phases = [
	"draw",
	"main",
	"rally",
	"end"
]

@warning_ignore("unused_signal")
signal phase_changed # use with a string for the phase as the parameter
signal player_changed_rally_status # use with player number and bool for status

func _ready() -> void:
	connect("player_changed_rally_status", player_rally_status_tracker)

func next_phase():
	current_phase_index += 1
	if current_phase_index > 3:
		current_phase_index = 0
	phase_switch(phases[current_phase_index])

func phase_switch(new_phase:String):
	match new_phase:
		"draw":
			CardHandler.player_draw_new_card(1, 1)
			CardHandler.player_draw_new_card(2, 1)
		"main":
			pass
		"rally":
			if player_1_wants_to_rally == true && player_2_wants_to_rally == true:
				print("Both players want to rally but I havent implemented it yet so Im skipping that")
				pass
			else:
				next_phase()
				print("One of the players chose to skip rally phase")
		"end": # TODO add points to whatever player didnt skip rally if applicable
			player_1_wants_to_rally = false
			player_2_wants_to_rally = false
			next_phase()
	emit_signal("phase_changed")
	print("Current phase: ", new_phase)

func player_rally_status_tracker(player:int, new_status:bool):
	match player:
		1:
			player_1_wants_to_rally = new_status
		2:
			player_2_wants_to_rally = new_status
	if player_1_wants_to_rally == true && player_2_wants_to_rally == true:
		next_phase()
	elif player_1_wants_to_rally == true && player_2_wants_to_rally == false || player_1_wants_to_rally == false && player_2_wants_to_rally == true:
		print("Both players still arent ready for rally")
	

func set_global_phase(new_phase:String): # Not really for use regularly
	
	player_1_phase = new_phase
	player_2_phase = new_phase
	
func next_player_phase(player:int, new_phase:String):
	match player:
		1:
			player_1_phase = new_phase
		2:
			player_1_phase = new_phase
