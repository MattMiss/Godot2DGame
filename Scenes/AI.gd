extends Node2D

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

onready var player_detect_zone = $PlayerDetectZone

var current_state = State.PATROL setget set_state
var player = null



func _process(_delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null:
				print("Engaging")



func set_state(new_state):
	if new_state == current_state:
		return
		
	current_state = new_state
	emit_signal("state_changed", current_state)

func _on_PlayerDetectZone_body_entered(body):
	if body.is_in_group("Player"):
		set_state(State.ENGAGE)
		player = body
