extends HBoxContainer

@export var player_owner = 0

func _ready() -> void:
	#get_player_owner()
	CardHandler.connect("player_draw_card", add_card_to_hand)
	CardHandler.connect("player_remove_card", remove_card_from_hand)

func add_card_to_hand(player_number: int, card_to_add = null):
	if player_number == player_owner:
		print("adding new card to player: ", player_owner)
		self.add_child(card_to_add)

func remove_card_from_hand(player_number:int, card_to_remove = null):
	if player_number == player_owner:
		self.get_node(card_to_remove).queue_free()
