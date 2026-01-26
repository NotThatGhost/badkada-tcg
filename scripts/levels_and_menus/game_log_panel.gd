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
}

var temporary_text_snapshot = ""

func _ready() -> void:
	GameLogHandler.connect("add_text_to_game_log", add_new_log_text)
	GameLogHandler.connect("add_card_used_to_game_log", add_new_card_desciption_log_text)
	text_field.append_text("[url="+str(debug_text_message)+str("]test link[/url]"))

func add_new_log_text(new_text : String):
	text_field.append_text(new_text +str("\n"))

func add_new_card_desciption_log_text(player_number : int, card_name : String, player_color : String):
	text_field.append_text("Player " + str(player_number) + " used: " + "[url=" + card_messages[card_name] + "][color=" + player_color + "]" + card_name + "[/color] [/url]")

func reset_text_field():
	text_field.set_text("")


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	if card_messages.has(card_messages.find_key(meta)):
		print(meta)
		text_field.parse_bbcode(meta)
		text_field.append_text("[img=48x72]" + str(CardHandler.card_textures[card_messages.find_key(meta)].get_path()) + "[/img]")
		return
	if meta is String:
		text_field.append_text(meta)
	print(meta)
