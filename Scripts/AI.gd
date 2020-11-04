extends Node2D


signal state_changed(new_state)
export var speed = 200
var current_state = State.PATROL setget set_state
var player = null
enum State {
	PATROL,
	ENGAGE,
	ATTACK
}
onready var enemy_self = owner
onready var player_detect_zone = $PlayerDetectZone


func _process(delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null:
				var velocity = enemy_self.position.direction_to(player.position)
				var angle = enemy_self.position.angle_to_point(player.position)
				enemy_self.move_and_collide(velocity * speed * delta)
				enemy_self.rotate_to_direction(rad2deg(angle))
				enemy_self.moving = true
		State.ATTACK:
			enemy_self.moving = false


func set_state(new_state):
	if new_state == current_state:
		return
	current_state = new_state
	emit_signal("state_changed", current_state)


func _on_PlayerDetectZone_body_entered(body):
	if body.is_in_group("Player"):
		set_state(State.ENGAGE)
		player = body


func _on_AttackDetectZone_body_entered(body):
	if body.is_in_group("Player"):
		set_state(State.ATTACK)
		player = body
		player.combat_started(enemy_self)
		
