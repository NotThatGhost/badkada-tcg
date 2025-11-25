extends Panel

var card_active = false

var card_owner : int
#var card_owner = [ # This is an array just in case I need to pull a string
	#"emptyspaceforreasons",
	#"player1",
	#"player2"
#]

var card_name = ""
var card_type = "no_type"

func _ready() -> void:
	TurnAndPhaseHandler.connect("phase_changed", set_card_usability)
	intitialize_card()

func check_card_usability(type_of_card:String):
# Yeah this ones a bit fucky but it should work and I have a deadline
	match type_of_card:
		"support":
			if TurnAndPhaseHandler.current_phase_index == 1:
				return true
			else:
				return false
		"skill":
			if TurnAndPhaseHandler.current_phase_index == 1 || TurnAndPhaseHandler.current_phase_index == 2:
				return true
			else:
				return false
		"talent":
			if TurnAndPhaseHandler.current_phase_index == 2:
				return true
			else:
				return false
		"event":
			if TurnAndPhaseHandler.current_phase_index == 1 || TurnAndPhaseHandler.current_phase_index == 2:
				return true
			else:
				return false
			

func set_card_usability(new_status=null):
	card_active = check_card_usability(card_type)
	if new_status != null:
		card_active = new_status
	else:
		pass
	if card_active == true:
		modulate = Color8(255, 255, 255, 255)
	elif card_active == false:
		modulate = Color8(20, 20, 20, 255)

func intitialize_card():
	$CARDNAME.set_text(card_name)
	$CARDTYPE.set_text(card_type)
	set_card_usability()

func use_card(): # Yup another hack, maybe I can get this to work with dictionaries
	match card_type:
		"skill":
			print("Skill card used")
			TurnAndPhaseHandler.emit_signal("player_changed_rally_status", card_owner, true)
			match card_name:
				"net_shot":
					pass
				"lift":
					pass
				"net_kill":
					pass
				"block":
					pass
				"push":
					pass
				"drive":
					pass
				"drop_shot":
					pass
				"clear":
					pass
				"smash":
					pass
		"talent":
			match card_name:
				"intimidate":
					pass
				"deception":
					pass
				"anticipate":
					pass
				"counter":
					pass
		"support":
			match card_name:
				"reversal":
					pass
				"break":
					pass
		"event":
			match card_name:
				"cancel":
					pass
	
	set_card_usability(false)

func _on_touch_screen_button_pressed() -> void:
	if card_active == true:
		use_card()
	elif card_active == false:
		print("Card unusable in current phase!")
