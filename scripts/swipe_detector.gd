extends Node2D

var length = 20
var start_position: Vector2
var current_position: Vector2
var swiping = false

var threshold = 10

signal swipe_upwards

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_input"):
		if !swiping:
			swiping = true
			start_position = get_global_mouse_position()
	if Input.is_action_pressed("ui_input"):
		if swiping:
			current_position = get_global_mouse_position()
			if start_position.distance_to(current_position) >= length:
				if abs(start_position.y-current_position.y) <= threshold:
					print("Horozontal Swiping")
					swiping = false
				elif abs(start_position.x - current_position.x) <= threshold:
					print("vertical swiping")
					if current_position.y < start_position.y:
						print("swiping upwards")
						swipe_upwards.emit()
					swiping = false
	else:
		swiping = false
