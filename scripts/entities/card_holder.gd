extends HBoxContainer

@export var player_owner = 0

func _ready() -> void:
	#get_player_owner()
	CardHandler.connect("player_draw_card", add_card_to_hand)
	CardHandler.connect("player_remove_card", remove_card_from_hand)
	CardHandler.connect("player_clear_card_holder", clear_card_holder)

func add_card_to_hand(player_number: int, card_to_add = null):
	if player_number == player_owner:
		self.add_child(card_to_add)

func remove_card_from_hand(player_number:int, card_to_remove = null):
	if player_number == player_owner:
		self.get_node(card_to_remove).queue_free()

func clear_card_holder(player_number:int):
	if player_number == player_owner:
		var children = get_children()
		for child in children:
			child.queue_free()
		
		#var i = 0
		#while i < self.get_child_count():
			#print("card holder child count: " , self.get_child_count())
			#print("Child to be deleted: ", self.get_child(0).name)
			#self.remove_child(get_child(0))
			#i += 1
