extends Control

const RALLY_CHOICE_POPUP_PATH = preload("res://scenes/menus/rally_choice_popup.tscn")

@onready var main_animation_player = $MainAnimationPlayer
@onready var secondary_animation_player = $SecondaryAnimationPlayer

@onready var score_label = $SCORELABEL
@onready var player_turn_indicator_label = $PlayerTurnIndicatorLabel
@onready var player_1_scroll_bar = $PlayArea_Player1/HScrollBar
@onready var player_2_scroll_bar = $PlayArea_Player2/HScrollBar
@onready var player_1_card_holder = $PlayArea_Player1/HScrollBar/CardHolder_Player1
@onready var player_2_card_holder = $PlayArea_Player2/HScrollBar/CardHolder_Player2
@onready var player_1_usable_card_indicator = $PlayArea_Player1/PhaseIndicator_Player1/UsableCardCountLabel
@onready var player_2_usable_card_indicator = $PlayArea_Player2/PhaseIndicator_Player2/UsableCardCountLabel
@export var player_scroll_bar_big_scale = Vector2(1.255, 1.255)
@export var player_scroll_bar_size_regular = Vector2(469, 163)
@export var player_scroll_bar_size_big = Vector2(382, 163)
@export var player_card_holder_separation_regular = 4
@export var player_card_holder_separation_big = 4
@export var test_var : int

var player_1_usable_card_indicator_number = 0
var player_2_usable_card_indicator_number = 0
	#set(new_value):
		#player_1_usable_card_indicator_number = new_value
		#player_1_usable_card_indicator.set_text(str(player_1_usable_card_indicator_number))

func _ready() -> void:
	$PlayArea_Player1/HScrollBar.horizontal_scroll_mode = 3
	$PlayArea_Player2/HScrollBar.horizontal_scroll_mode = 3
	CardHandler.connect("card_used", update_card_used_text)
	CardHandler.card_used.connect(update_player_card_indicator_text)
	TurnAndPhaseHandler.player_1_card_holder = $PlayArea_Player1/HScrollBar/CardHolder_Player1
	TurnAndPhaseHandler.player_2_card_holder = $PlayArea_Player2/HScrollBar/CardHolder_Player2
	update_phase_label_text()
	$DeckIcon/DECKSIZECOUNT.set_text(str(CardHandler.game_use_deck.size()))
	TurnAndPhaseHandler.connect("phase_changed", update_phase_label_text)
	CardHandler.connect("power_select_screen_activate", activate_power_select_popup)
	#CardHandler.card_created.connect(update_player_1_card_indicator_text)
	#CardHandler.add_card_to_grid.connect(update_player_1_card_indicator_text)
	CardHandler.card_visibility_set.connect(update_player_card_indicator_text)
	TurnAndPhaseHandler.draw_phase_entered.emit()
	TurnAndPhaseHandler.player_turn_changed.connect(update_player_scroll_bar_scale)
	TurnAndPhaseHandler.player_turn_changed.connect(update_player_turn_indicator_label_text)
	TurnAndPhaseHandler.draw_phase_entered.connect(play_player_turn_indicator_animation)
	TurnAndPhaseHandler.player_1_pass_rally.connect(play_player_rally_pass_animation)
	TurnAndPhaseHandler.show_game_score.connect(play_score_animation)
	TurnAndPhaseHandler.phase_changed.connect(play_phase_change_sfx)
	update_player_scroll_bar_scale(1)
	#CardHandler.player_draw_new_card(1, 12)
	#CardHandler.player_draw_new_card(2, 12)
	#CardHandler.player_draw_new_card(1, 1, null, "deception1")
	await get_tree().create_timer(1).timeout
	$MainAnimationPlayer.play("beginning_draw_animation")
	await $MainAnimationPlayer.animation_finished
	TurnAndPhaseHandler.next_phase()
	
	#CardHandler.player_draw_new_card(1, 1, "reversal")
	
func _physics_process(delta: float) -> void:
	pass

func update_player_card_indicator_text():
	player_1_usable_card_indicator_number = 0
	player_2_usable_card_indicator_number = 0
	var i = 0
	while i < player_1_card_holder.get_child_count():
		if player_1_card_holder.get_child(i).visible == true:
			player_1_usable_card_indicator_number += 1
		i += 1
	i = 0
	while i < player_2_card_holder.get_child_count():
		if player_2_card_holder.get_child(i).visible == true:
			player_2_usable_card_indicator_number += 1
		i += 1
	player_2_usable_card_indicator.set_text(str(player_2_usable_card_indicator_number))
	player_1_usable_card_indicator.set_text(str(player_1_usable_card_indicator_number))

func main_scene_draw_card(player:int, amount: int):
	CardHandler.player_draw_new_card(player, amount)
	$DeckIcon/DECKSIZECOUNT.set_text(str(CardHandler.game_use_deck.size()))

func update_card_used_text():
	$PLAYERCARDUSEINDICATORLABEL.set_text("Player " +str(TurnAndPhaseHandler.player_in_turn) +str(" used ") +str(CardHandler.most_recent_used_card))

func update_phase_label_text():
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	var new_text = TurnAndPhaseHandler.phases[TurnAndPhaseHandler.current_phase_index]
	
	$PHASELABEL.set_text(new_text +str(" phase"))
	$PHASELABEL2.set_text(new_text +str(" phase"))
	tween.tween_property($PHASELABEL, "visible_characters",20, 1)
	tween2.tween_property($PHASELABEL2, "visible_characters", 20, 1)
	
	match TurnAndPhaseHandler.current_phase_index:
		0:
			move_phase_indicator_arrow(1, 2, 53)
			move_phase_indicator_arrow(2, 2, 53)
		1:
			move_phase_indicator_arrow(1, 156, 53)
			move_phase_indicator_arrow(2, 156, 53)
		2:
			move_phase_indicator_arrow(1, 3, 102)
			move_phase_indicator_arrow(2, 3, 102)
		3:
			move_phase_indicator_arrow(1, 152, 102)
			move_phase_indicator_arrow(2, 152, 102)

func move_phase_indicator_arrow(player_number,x : float, y : float):
	var tween = get_tree().create_tween()
	match player_number:
		1:
			tween.tween_property($PlayArea_Player1/PhaseIndicator_Player1/PhaseIndicatorArrow, "position", Vector2(x, y), 0.2)
			#$PlayArea_Player1/PhaseIndicator_Player1/PhaseIndicatorArrow.position = Vector2(x, y)
		2:
			tween.tween_property($PlayArea_Player2/PhaseIndicator_Player2/PhaseIndicatorArrow, "position", Vector2(x, y), 0.2)
			#$PlayArea_Player2/PhaseIndicator_Player2/PhaseIndicatorArrow.position = Vector2(x, y)

func activate_power_select_popup(player:int, new_status:bool):
	match player:
		1:
			$Player1DeceptionPanel.visible = new_status
			CardHandler.power_select_screen_visible_player_1 = new_status
		2:
			pass
			

func set_player_1_usable_card_indicator(value):
	value = CardHandler.player_1_cards.size()
	player_1_usable_card_indicator.set_text(CardHandler.player_1_cards.size())
	print("cock")

func update_player_scroll_bar_scale(player_in_turn : int):
	player_1_scroll_bar.scale = Vector2(1, 1)
	player_2_scroll_bar.scale = Vector2(1, 1)
	player_1_scroll_bar.size = player_scroll_bar_size_regular
	player_2_scroll_bar.size = player_scroll_bar_size_regular
	player_1_card_holder.add_theme_constant_override("separation", player_card_holder_separation_regular)
	player_2_card_holder.add_theme_constant_override("separation", player_card_holder_separation_regular)
	match player_in_turn:
		1:
			player_1_scroll_bar.scale = player_scroll_bar_big_scale
			player_1_scroll_bar.size = player_scroll_bar_size_big
			player_1_card_holder.add_theme_constant_override("separation", player_card_holder_separation_big)
		2:
			player_2_scroll_bar.scale = player_scroll_bar_big_scale
			player_2_scroll_bar.size = player_scroll_bar_size_big
			player_2_card_holder.add_theme_constant_override("separation", player_card_holder_separation_big)

func update_player_turn_indicator_label_text(player_in_turn : int):
	player_turn_indicator_label.text = "Player " +str(player_in_turn)

func update_score_label():
	score_label.set_text(str(ScoreHandler.player_1_score) +str(" - ") +str(ScoreHandler.player_2_score))

func play_player_turn_indicator_animation():
	secondary_animation_player.play("show_player_turn_indicator_label")

func play_score_animation():
	main_animation_player.play("show_score")

func play_player_rally_pass_animation():
	secondary_animation_player.play("show_player_1_pass_indicator")
	
	
func play_phase_change_sfx():
	SoundEffectsManager.phase_change_sfx.play()
func _on_rally_choice_popup_zone_button_pressed() -> void:
	var new_rally_choice_popup = RALLY_CHOICE_POPUP_PATH.instantiate()
	get_parent().add_child(new_rally_choice_popup)
	new_rally_choice_popup.global_position = get_global_mouse_position()


func player_1_power_button_function(selected_power:int):
	CardHandler.player_1_selected_card_power = selected_power
	$Player1DeceptionPanel.visible = false
	CardHandler.power_select_screen_visible_player_1 = false

func _on_strength_button_1_pressed() -> void:
	player_1_power_button_function(1)


func _on_strength_button_2_pressed() -> void:
	player_1_power_button_function(2)


func _on_strength_button_3_pressed() -> void:
	player_1_power_button_function(3)
