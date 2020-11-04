extends KinematicBody2D


var move_direction
var moving = false
var player = null
var anim_mode = "Idle"
var anim_direction
var animation
onready var ai = $AI

enum State {
	PATROL,
	ENGAGE,
	ATTACK
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play(anim_mode)


func _process(_delta):
	if moving == true:
		anim_mode = "Walk"
		#if not $Footsteps.is_playing():
		#	$Footsteps.play()
	elif moving == false:
		anim_mode = "Idle"
		$AnimationPlayer.play(anim_mode)
		#if $Footsteps.is_playing():
		#	$Footsteps.stop()
	


func rotate_to_direction(move_direction):
	print(move_direction)
	
	if moving:
		if move_direction > -45 and move_direction <= 45:
			anim_direction = "Left"
		elif move_direction > 45 and move_direction < 135:
			anim_direction = "Up"
		elif move_direction >= -135 and move_direction <= -45:
			anim_direction = "Down"
		elif move_direction >= 135 or move_direction < -135:
			anim_direction = "Right"
		animation = anim_mode + "_" + anim_direction
		$AnimationPlayer.play(animation)



func _on_AI_state_changed(new_state):
	match new_state:
		State.PATROL:
			pass
		State.ENGAGE:
			pass
		State.ATTACK:
			print("Poop")
			$AnimationPlayer.play("Idle")
			get_tree().root.get_node("Game/OutdoorMusic").stop()
			get_tree().root.get_node("Game/IndoorMusic").stop()
			get_tree().root.get_node("Game/BattleMusic").play()
			

func change_to_battle_size():
	scale.x = 5
	scale.y = 5

