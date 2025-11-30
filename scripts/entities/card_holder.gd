extends HBoxContainer

@export var player_owner = 0

func _ready() -> void:
	#get_player_owner()
	CardHandler.connect("player_draw_card", add_card_to_hand)

func add_card_to_hand(player_number: int, card_to_add = null):
	if player_number == player_owner:
		print("adding new card to player: ", player_owner)
		self.add_child(card_to_add)
