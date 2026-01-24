extends Panel

@onready var text_field = $ScrollContainer/RichTextLabel

@export_group("Debug")
@export_multiline var debug_text_message = ""
@export_group("Card Descriptions")
@export_subgroup("Skill Cards")
@export_multiline var net_shot = ""
@export_multiline var lift = ""
@export_multiline var net_kill = ""
@export_multiline var block = ""
@export_multiline var push = ""
@export_multiline var drive = ""
@export_multiline var drop_shot = ""
@export_multiline var clear = ""
@export_multiline var smash = ""
@export_subgroup("Talent Cards")
@export_multiline var intimidate = ""
@export_multiline var deception = ""
@export_multiline var anticipate = ""
@export_multiline var counter = ""
@export_subgroup("Support Cards")
@export_multiline var reversal = ""
@export_multiline var break_message = ""
@export_subgroup("Event Cards")
@export_multiline var cancel = ""


var temporary_text_snapshot = ""

func _ready() -> void:
	GameLogHandler.connect("add_text_to_game_log", add_new_log_text)
	text_field.append_text("[url="+str(debug_text_message)+str("]test link[/url]"))

func add_new_log_text(new_text : String):
	text_field.append_text(new_text +str("\n"))

func reset_text_field():
	text_field.set_text("")


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	if meta is String:
		add_new_log_text(meta)
	print(meta)
