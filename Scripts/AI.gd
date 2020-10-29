extends Node2D

export var speed = 200
onready var enemy_self = owner

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

onready var player_detect_zone = $PlayerDetectZone

var current_state = State.PATROL setget set_state
var player = null



func _process(delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null:
				var velocity = enemy_self.position.direction_to(player.position)
				var angle = enemy_self.position.angle_to_point(player.position)
				enemy_self.move_and_collide(velocity * speed * delta)
				enemy_self.MoveInDirection(angle)
				enemy_self.moving = true




func set_state(new_state):
	if new_state == current_state:
		return
		
	current_state = new_state
	emit_signal("state_changed", current_state)

func _on_PlayerDetectZone_body_entered(body):
	if body.is_in_group("Player"):
		set_state(State.ENGAGE)
		player = body
