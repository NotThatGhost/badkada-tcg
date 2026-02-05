extends TextureRect

const USED_CARD_INDICATOR_PATH = preload("res://scenes/cards/used_card_indicator.tscn")

@onready var player_1_grid = $MarginContainerP1/CardIndicatorGridPlayer1
@onready var player_2_grid = $MarginContainerP2/CardIndicatorGridPlayer2

@onready var player_1_card_indicator_spawn = $Player1UsedCardIndicatorSpawn
@onready var player_2_card_indicator_spawn = $Player2UsedCardIndicatorSpawn
@onready var used_card_indicator_deck = $UsedCardIndicatorDeckPosition

func _ready() -> void:
	CardHandler.connect("add_card_to_grid", create_new_used_card_indicator)
	TurnAndPhaseHandler.connect("draw_phase_entered", clear_grids)
#region card indicator stuff
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
#endregion

func create_new_used_card_indicator(player_owner : int, card_name : String):
	var new_used_card_indicator = USED_CARD_INDICATOR_PATH.instantiate()
	new_used_card_indicator.get_node("TextureRect").texture = CardHandler.card_textures[card_name]
	get_parent().add_child(new_used_card_indicator)
	match player_owner:
		1:
			new_used_card_indicator.global_position = player_1_card_indicator_spawn.global_position
			new_used_card_indicator.scale = Vector2(2, 2)
		2:
			new_used_card_indicator.global_position = player_2_card_indicator_spawn.global_position
			new_used_card_indicator.scale = Vector2(2, 2)
	var tween = get_tree().create_tween()
	var tween_2 = get_tree().create_tween()
	tween.tween_property(new_used_card_indicator, "global_position", used_card_indicator_deck.global_position, 0.3)
	tween_2.tween_property(new_used_card_indicator, "scale", Vector2(1.5, 1.5), 0.3)
	
	
