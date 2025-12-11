extends Node

const NEW_CARD_PATH = preload("res://scenes/cards/card.tscn")

#@onready var card_holder_player_1_path = $PlayArea_Player1/HScrollBar/CardHolder_Player1

var times_set_usability = 0

var hide_player_2_cards = false

var cancel_card_in_effect = false
var anticipate_card_in_effect = false
var counter_card_in_effect = false
var power_select_screen_visible_player_1 = true
var power_select_screen_visible_player_2 = true

var player_1_cards = []
var player_2_cards = []

var player_1_current_target = ""
var player_2_current_target = ""
var player_1_selected_card = ""
var player_2_selected_card = ""
var player_1_selected_card_count = 0
var player_2_selected_card_count = 0
var player_1_selected_card_power = 0
var player_2_selected_card_power = 0

var empty_array = ["empty_space"]

var player_1_usable_cards = []
var player_2_usable_cards = []

var player_1_selected_card_traits = []
var player_2_selected_card_traits = []

var player_1_card_use_buffer = 0
var player_2_card_use_buffer = 0


var player_1_current_power = 0
var player_2_current_power = 0

var permanent_deck = [
	"intimidate",
	"intimidate",
	"deception",
	"deception",
	"deception",
	"anticipate",
	"anticipate",
	"counter",
	"counter",
	"reversal",
	"break",
	"break",
	"break",
	"break",
	"cancel",
	"net_shot",
	"lift",
	"net_kill",
	"block",
	"push",
	"drive",
	"drop_shot",
	"clear",
	"smash"
] # Going to have the card types that the card will get its type from when spawning
# Also will have the actual names of the cards not just the basic types

var permanent_deck2 = {
		"intimidate1" : ["intimidate", "talent"],
		"intimidate2" : ["intimidate", "talent"],
		"deception1" : ["deception", "talent"],
		"deception2" : ["deception", "talent"],
		"deception3" : ["deception", "talent"],
		"anticipate1" : ["anticipate", "talent"],
		"anticipate2" : ["anticipate", "talent"],
		"counter1" : ["counter", "talent"],
		"counter2" : ["counter", "talent"],
		"reversal" : ["reversal", "support"],
		"break1" : ["break", "support"],
		"break2" : ["break", "support"],
		"break3" : ["break", "support"],
		"break4" : ["break", "support"],
		"cancel" : ["break", "event"],
		"net_shot1" : ["net_shot", "skill", 1],
		"net_shot2" : ["net_shot", "skill", 2],
		"net_shot3" : ["net_shot", "skill", 3],
		"lift1" : ["lift", "skill", 1],
		"lift2" : ["lift", "skill", 2],
		"lift3" : ["lift", "skill", 3],
		"net_kill1" : ["net_kill", "skill", 1],
		"net_kill2" : ["net_kill", "skill", 2],
		"net_kill3" : ["net_kill", "skill", 3],
		"block1" : ["block", "skill", 1],
		"block2" : ["block", "skill", 2],
		"block3" : ["block", "skill", 3],
		"push1" : ["push", "skill", 1],
		"push2" : ["push", "skill", 2],
		"push3" : ["push", "skill", 3],
		"drive1" : ["drive", "skill", 1],
		"drive2" : ["drive", "skill", 2],
		"drive3" : ["drive", "skill", 3],
		"drop_shot1" : ["drop_shot", "skill", 1],
		"drop_shot2" : ["drop_shot", "skill", 2],
		"drop_shot3" : ["drop_shot", "skill", 3],
		"clear1" : ["clear", "skill", 1],
		"clear2" : ["clear", "skill", 2],
		"clear3" : ["clear", "skill", 3],
		"smash1" : ["smash", "skill", 1],
		"smash2" : ["smash", "skill", 2],
		"smash3" : ["smash", "skill", 3]
}

var game_use_deck = {} # Will get its contents on game startup for use without fucking up the permanent deck

var skill_cards = [
	"net_shot",
	"lift",
	"net_kill",
	"block",
	"push",
	"drive",
	"drop_shot",
	"clear",
	"smash"
]
var talent_cards = [
	"intimidate",
	"deception",
	"anticipate",
	"counter"
]
var support_cards = [
	"reversal",
	"break"
]
var event_cards = [
	"cancel"
]

var card_types = [
	"skill",
	"talent",
	"support",
	"event"
]

var card_target_areas = [
	"forecourt",
	"midcourt",
	"rearcourt"
]

signal player_draw_card # call with player number and instanced node
signal player_remove_card # call with player number and card name
signal player_clear_card_holder # call with player number
signal card_used # dont call with anything
signal card_selected # dont call with anything
signal reset_card_usage # dont call with anything
signal set_usability
signal power_select_screen_activate
#var card_names = [
	#"intimidate",
	#"deception",
	#"anticipate",
	#"counter",
	#"reversal",
	#"break",
	#"cancel"
#]

func _ready() -> void:
	reset_deck()
	#connect("card_used", )
	#TurnAndPhaseHandler.connect("main_phase_entered", clear_player_usable_cards)
	#TurnAndPhaseHandler.connect("rally_phase_entered", clear_player_usable_cards)

func reset_deck():
	game_use_deck = permanent_deck2.duplicate(true)
	permanent_deck2.make_read_only()
	print("resetting deck")

func get_card_type_from_name(card_name:String):
	if skill_cards.has(card_name):
		return 0
	elif talent_cards.has(card_name):
		return 1
	elif support_cards.has(card_name):
		return 2
	elif event_cards.has(card_name):
		return 3
	else:
		print("shits fucked with the cards")

func dictionary_pick_random(dictionary:Dictionary):
	var random_key = dictionary.keys().pick_random()
	print(random_key)
	return dictionary[random_key]

func player_draw_new_card(player:int, amount:int, power_level = null, specific_card = null):
	#print("Starting draw deck size: ", game_use_deck.size())
	print("Game use deck size = ", game_use_deck.size())
	if game_use_deck.size() == 0:
		print("AHHHH TRYIN TO DRAW A CARD CANT DO IT DECKS EMPTY")
		return
	if specific_card != null:
		print("Drawing specific card: ", specific_card)

		#print("Specific card isnt null")
		#print(permanent_deck.has(specific_card))
		if permanent_deck2.has(specific_card) == true:
			for n in amount:
				var new_card_info = permanent_deck2[specific_card]
				print("permanent deck has specific card")
				var new_card = NEW_CARD_PATH.instantiate()
				new_card.card_name = new_card_info[0]
				new_card.card_type = new_card_info[1]
				new_card.card_owner = player
				new_card.name = new_card.card_name
				if new_card.card_type == "skill":
					new_card.power_level = new_card_info[2]
				emit_signal("player_draw_card", player, new_card)
				match player:
					1:
						player_1_cards.append(permanent_deck2.find_key(new_card_info))
						
					2:
						player_2_cards.append(permanent_deck2.find_key(new_card_info))
			return
		else:
			print("Permanent deck does not have card: ", specific_card)
			return
	for n in amount:
		var new_card_info = dictionary_pick_random(game_use_deck)
		var new_card = NEW_CARD_PATH.instantiate()
		new_card.card_name = new_card_info[0]
		new_card.card_type = new_card_info[1]
		new_card.card_owner = player
		
		new_card.name = new_card.card_name
		
		if new_card.card_type == "skill":
			new_card.power_level = new_card_info[2]
		match player:
			1:
				player_1_cards.append(permanent_deck2.find_key(new_card_info))
			2:
				player_2_cards.append(permanent_deck2.find_key(new_card_info))
		
		emit_signal("player_draw_card", player, new_card)
		game_use_deck.erase(game_use_deck.find_key(new_card_info))
		#match player:
			#1:
				#player_1_cards.append(new_card_info[0])
			#2:
				#player_2_cards.append(new_card_info[0])
		#game_use_deck.erase(new_card.card_name)
	#print("Ending draw deck size: ", game_use_deck.size())

func reset_player_card_scenes(player:int):
	match player:
		1:
			emit_signal("player_clear_card_holder", 1)
			for n in player_1_cards.size():
				player_draw_new_card(1, 1, null, player_1_cards[n])
		2:
			for n in player_2_cards.size():
				player_draw_new_card(2, 1, null, player_2_cards[n])
		

func clear_player_usable_cards():
	player_1_usable_cards = empty_array.duplicate()
	player_2_usable_cards = empty_array.duplicate()
	player_1_usable_cards.erase("empty_space")
	player_2_usable_cards.erase("empty_space")

func reversal_card_effect():
	var player_1_new_cards = CardHandler.player_2_cards.duplicate()
	var player_2_new_cards = CardHandler.player_1_cards.duplicate()
	
	CardHandler.player_1_cards.clear()
	CardHandler.player_2_cards.clear()
	
	print(player_1_cards)
	print(player_2_cards)
	CardHandler.player_1_cards.append(player_1_new_cards)
	CardHandler.player_2_cards.append(player_2_new_cards)
	
	CardHandler.emit_signal("player_clear_card_holder", 1)
	CardHandler.emit_signal("player_clear_card_holder", 2)
	
	for n in player_1_new_cards.size():
		CardHandler.player_draw_new_card(1, 1, null, player_1_new_cards[n])
		#print("one cycle of player 1 swap done")
	for n in player_2_new_cards.size():
		CardHandler.player_draw_new_card(2, 1, null, player_2_new_cards[n])

func get_card_type_count(player:int, card_type_count_query:String):
	match player:
		1:
			return player_1_cards.count(card_type_count_query)
		2:
			return player_2_cards.count(card_type_count_query)

#func use_card_when_selected(player:int):
	#match player:
		#1:
			#if player_1_selected_card_count > 0:
				#
		#2:
			#pass
			
