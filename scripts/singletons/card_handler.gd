extends Node

const NEW_CARD_PATH = preload("res://scenes/cards/card.tscn")

#@onready var card_holder_player_1_path = $PlayArea_Player1/HScrollBar/CardHolder_Player1

var player_1_cards = []
var player_2_cards = []

var permanent_deck = [
	"intimidate",
	"deception",
	"anticipate",
	"counter",
	"reversal",
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

signal player_draw_card # call with player number and instanced node

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
	game_use_deck = permanent_deck
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

func player_draw_new_card(player:int, amount:int):
	print("Starting draw deck size: ", game_use_deck.size())
	if game_use_deck.size() == 0:
		print("AHHHH TRYIN TO DRAW A CARD CANT DO IT DECKS EMPTY")
		return
	var i = 0
	while i < amount:
		var new_card_name = game_use_deck.pick_random()
		var new_card_type = get_card_type_from_name(new_card_name)
		var new_card = NEW_CARD_PATH.instantiate()
		new_card.card_name = new_card_name
		new_card.card_type = card_types[new_card_type]
		new_card.card_owner = player
		emit_signal("player_draw_card", player, new_card)
		match player:
			1:
				player_1_cards.append(new_card.card_type)
			2:
				player_2_cards.append(new_card.card_type)
		game_use_deck.erase(new_card.card_name)
		i += 1
	print("Ending draw deck size: ", game_use_deck.size())

func get_card_type_count(player:int, card_type_count_query:String):
	match player:
		1:
			return player_1_cards.count(card_type_count_query)
		2:
			return player_2_cards.count(card_type_count_query)
