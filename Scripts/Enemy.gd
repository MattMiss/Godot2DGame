extends KinematicBody2D

onready var ai = $AI
var move_direction
var moving = false
var anim_mode = "Idle"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play(anim_mode)

func _process(_delta):
	if moving == true:
		anim_mode = "Walk"
		print("walk")
		#if not $Footsteps.is_playing():
		#	$Footsteps.play()
	elif moving == false:
		anim_mode = "Idle"
		#if $Footsteps.is_playing():
		#	$Footsteps.stop()
	$AnimationPlayer.play(anim_mode)

func MoveInDirection(angle):
	if moving != true:
		moving == true
	print("moving")
