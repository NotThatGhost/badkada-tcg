extends Panel

@onready var text_field = $ScrollContainer/RichTextLabel

@export_group("Debug")
@export_multiline var debug_text_message = ""
@export_group("Card Descriptions")
@export_subgroup("Skill Cards")
@export_multiline var net_shot_message = ""
@export_multiline var lift_message = ""
@export_multiline var net_kill_message = ""
@export_multiline var block_message = ""
@export_multiline var push_message = ""
@export_multiline var drive_message = ""
@export_multiline var drop_shot_message = ""
@export_multiline var clear_message = ""
@export_multiline var smash_message = ""
@export_subgroup("Talent Cards")
@export_multiline var intimidate_message = ""
@export_multiline var deception_message = ""
@export_multiline var anticipate_message = ""
@export_multiline var counter_message = ""
@export_subgroup("Support Cards")
@export_multiline var reversal_message = ""
@export_multiline var break_message = ""
@export_subgroup("Event Cards")
@export_multiline var cancel_message = ""

@onready var card_messages = {
	"net_shot" : net_shot_message,
	"lift" : lift_message,
	"net_kill" : net_kill_message,
	"block" : block_message,
	"push" : push_message,
	"drive" : drive_message,
	"drop_shot" : drop_shot_message,
	"clear" : clear_message,
	"smash" : smash_message,
	"intimidate" : intimidate_message,
	"deception" : deception_message,
	"anticipate" : anticipate_message,
	"counter" : counter_message,
	"reversal" : reversal_message,
	"break" : break_message,
	"cancel" : cancel_message,
}

var temporary_text_snapshot = ""

func _ready() -> void:
	GameLogHandler.change_game_log_panel_visibility.connect(change_game_log_panel_visibility)
	GameLogHandler.connect("add_text_to_game_log", add_new_log_text)
	GameLogHandler.connect("add_card_used_to_game_log", add_new_card_desciption_log_text)
	#text_field.append_text("[url="+str(debug_text_message)+str("]test link[/url]"))

func add_new_log_text(new_text : String):
	text_field.append_text(new_text +str("\n"))
	temporary_text_snapshot += (new_text +str("\n"))
	print("Temp text buffer: \n" +temporary_text_snapshot)

func add_new_card_desciption_log_text(player_number : int, card_name : String, player_color : String):
	#text_field.append_text("Player " + str(player_number) + " used: " + "[url=" + card_messages[card_name] + "][color=" + player_color + "]" + card_name + "[/color] [/url]")
	#text_field.append_text("\n")
	add_new_log_text("Player " + str(player_number) + " used: " + "[url=" + card_messages[card_name] + "][color=" + player_color + "]" + card_name + "[/color][/url]")

func change_game_log_panel_visibility(new_status : bool):
	visible = new_status

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	
	if card_messages.has(card_messages.find_key(meta)):
		print(meta)
		text_field.text = ("[center][img=96x144]" + str(CardHandler.card_textures[card_messages.find_key(meta)].get_path()) + "[/img][/center]" + "\n" +meta)
		
		return
	if meta is String:
		text_field.append_text(meta)

func _on_undo_button_pressed() -> void:
	text_field.text = temporary_text_snapshot

func _on_exit_button_pressed() -> void:
	change_game_log_panel_visibility(false)
