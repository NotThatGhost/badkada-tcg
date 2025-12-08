extends Node

const NEW_CARD_PATH = preload("res://scenes/cards/card.tscn")

#@onready var card_holder_player_1_path = $PlayArea_Player1/HScrollBar/CardHolder_Player1

var hide_player_2_cards = false

var cancel_card_in_effect = false

var player_1_cards = []
var player_2_cards = []

var player_1_current_target = ""
var player_2_current_target = ""
var player_1_selected_card = ""
var player_2_selected_card = ""
var player_1_selected_card_count = 0
var player_2_selected_card_count = 0


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
		"net_shot" : ["net_shot", "skill", 1],
		"lift" : ["lift", "skill", 1],
		"net_kill" : ["net_kill", "skill", 1],
		"block" : ["block", "skill", 1],
		"push" : ["push", "skill", 1],
		"drive" : ["drive", "skill", 1],
		"drop_shot" : ["drop_shot", "skill", 1],
		"clear" : ["clear", "skill", 1],
		"smash" : ["smash", "skill", 1]
}

var game_use_deck = [] # Will get its contents on game startup for use without fucking up the permanent deck

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

func reset_deck():
	game_use_deck = permanent_deck.duplicate(true)
	permanent_deck.make_read_only()
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

func player_draw_new_card(player:int, amount:int, power_level = null, specific_card = null):
	#print("Starting draw deck size: ", game_use_deck.size())
	if game_use_deck.size() == 0:
		print("AHHHH TRYIN TO DRAW A CARD CANT DO IT DECKS EMPTY")
		return
	if specific_card != null:
		#print("Specific card isnt null")
		#print(permanent_deck.has(specific_card))
		if permanent_deck.has(specific_card) == true:
			for n in amount:
				#print("permanent deck has specific card")
				var new_card_name = specific_card
				var new_card_type = get_card_type_from_name(new_card_name)
				var new_card = NEW_CARD_PATH.instantiate()
				new_card.card_name = new_card_name
				new_card.card_type = card_types[new_card_type]
				new_card.card_owner = player
				new_card.name = new_card_name
				new_card.power_level = power_level
				emit_signal("player_draw_card", player, new_card)
				match player:
					1:
						player_1_cards.append(new_card.card_name)
					2:
						player_2_cards.append(new_card.card_name)
			return
	for n in amount:
		var new_card_name = game_use_deck.pick_random()
		var new_card_type = get_card_type_from_name(new_card_name)
		var new_card = NEW_CARD_PATH.instantiate()
		new_card.card_name = new_card_name
		new_card.card_type = card_types[new_card_type]
		new_card.card_owner = player
		new_card.name = new_card_name
		if new_card.card_type == "skill":
			match player:
				1:
					TurnAndPhaseHandler.player_1_skill_card_count += 1
				2:
					TurnAndPhaseHandler.player_2_skill_card_count += 1
		emit_signal("player_draw_card", player, new_card)
		match player:
			1:
				player_1_cards.append(new_card.card_name)
			2:
				player_2_cards.append(new_card.card_name)
		#game_use_deck.erase(new_card.card_name)
	#print("Ending draw deck size: ", game_use_deck.size())

func reversal_card_effect():
	var player_1_new_cards = CardHandler.player_2_cards.duplicate()
	var player_2_new_cards = CardHandler.player_1_cards.duplicate()
	var player_1_new_skill_card_count = TurnAndPhaseHandler.player_2_skill_card_count
	var player_2_new_skill_card_count = TurnAndPhaseHandler.player_1_skill_card_count
	
	TurnAndPhaseHandler.reset_skill_card_counts()
	
	TurnAndPhaseHandler.player_1_skill_card_count = player_1_new_skill_card_count
	TurnAndPhaseHandler.player_2_skill_card_count = player_2_new_skill_card_count
	
	CardHandler.player_1_cards.clear()
	CardHandler.player_2_cards.clear()
	
	print(player_1_cards)
	print(player_2_cards)
	CardHandler.player_1_cards.append(player_1_new_cards)
	CardHandler.player_2_cards.append(player_2_new_cards)
	

	
	CardHandler.emit_signal("player_clear_card_holder", 1)
	CardHandler.emit_signal("player_clear_card_holder", 2)
	

	
	for n in player_1_new_cards.size():
		CardHandler.player_draw_new_card(1, 1, player_1_new_cards[n])
		#print("one cycle of player 1 swap done")
	
	for n in player_2_new_cards.size():
		CardHandler.player_draw_new_card(2, 1, player_2_new_cards[n])

func get_card_type_count(player:int, card_type_count_query:String):
	match player:
		1:
			return player_1_cards.count(card_type_count_query)
		2:
			return player_2_cards.count(card_type_count_query)
