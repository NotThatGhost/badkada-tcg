extends TextureRect

const USED_CARD_INDICATOR_PATH = preload("res://scenes/cards/used_card_indicator.tscn")

@onready var player_1_grid = $MarginContainerP1/CardIndicatorGridPlayer1
@onready var player_2_grid = $MarginContainerP2/CardIndicatorGridPlayer2

func _ready() -> void:
	CardHandler.connect("add_card_to_grid", add_card_indicator_to_player_grid)
	TurnAndPhaseHandler.connect("draw_phase_entered", clear_grids)

func add_card_indicator_to_player_grid(player:int, card_name:String):
	var new_used_card_indicator = USED_CARD_INDICATOR_PATH.instantiate()
	match player:
		1:
			player_1_grid.add_child(new_used_card_indicator)
		2:
			player_2_grid.add_child(new_used_card_indicator)
	new_used_card_indicator.get_node("TextureRect").texture = CardHandler.card_textures[card_name]


func clear_grids():
	print("Clearing grids!")
	var player_1_grid_children = player_1_grid.get_children()
	for child in player_1_grid_children:
		child.queue_free()
	var player_2_grid_children = player_2_grid.get_children()
	for child in player_2_grid_children:
		child.queue_free()
