extends KinematicBody2D


var anim_direction = "Down"
var anim_mode = "Idle"
var animation

var max_speed = 400
var speed = 0
var acceleration  = 1200
var move_direction = 90
var moving = false
var destination = Vector2()
var movement  = Vector2() 
var next_attack_time = 0
var attack_cooldown_time = 1
var clicked = false
var cast_line

func _unhandled_input(event):
	if event.is_action_pressed("Click"):
		moving = true
		clicked = true
		destination = get_global_mouse_position()
	elif event.is_action_pressed("Interact"):
		# Check if player can attack
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			# What's the target?
			var target = $RayCast2D.get_collider()
			#print(target)
			if target != null:
				#print(target.name)
				# NEW CODE - START
				if target.is_in_group("NPCs"):
					# Talk to NPC
					target.talk()
					return
				if target.name == "Bed":
					# Sleep
					print("Its a bed")
					get_tree().root.get_node("Root/CanvasLayer/AnimationPlayer").play("Sleep")
					yield(get_tree().create_timer(1), "timeout")
					return
				# NEW CODE - END
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time


	
	
func _process(_delta):
	AnimationLoop()
	RayCastAngleLoop()	
	
func _physics_process(delta):
	if (clicked):
		MovementLoop(delta)
	else:
		DirectionMoveLoop()
		movement = move_and_slide(movement)


func DirectionMoveLoop():
	movement = Vector2()
	if Input.is_action_pressed('right'):
		moving = true
		movement.x += 1
		move_direction = 0
	if Input.is_action_pressed('left'):
		moving = true
		movement.x -= 1
		move_direction = 180
	if Input.is_action_pressed('down'):
		moving = true
		movement.y += 1
		move_direction = 90
	if Input.is_action_pressed('up'):
		moving = true
		movement.y -= 1
		move_direction = -90
	
	movement = movement.normalized() * max_speed
	if movement.x == 0 and movement.y == 0:
		moving = false
	#print(movement)
	

func MovementLoop(delta):
	speed += acceleration * delta
	if speed > max_speed:
		speed = max_speed
	movement = position.direction_to(destination) * speed
	move_direction = rad2deg(destination.angle_to_point(position))
	if position.distance_to(destination) > 5:
		movement = move_and_slide(movement)
	else:
		moving = false
		clicked = false


func AnimationLoop():
	anim_direction = "Down"
	
	#print(move_direction)
	if move_direction > -45 and move_direction <= 45:
		anim_direction = "Right"
	elif move_direction > 45 and move_direction < 135:
		anim_direction = "Down"
	elif move_direction >= -135 and move_direction <= -45:
		anim_direction = "Up"
	elif move_direction >= 135 or move_direction < -135:
		anim_direction = "Left"
		
	if moving == true:
		anim_mode = "Walk"
		if not $Footsteps.is_playing():
			$Footsteps.play()
	elif moving == false:
		anim_mode = "Idle"
		if $Footsteps.is_playing():
			$Footsteps.stop()
	animation = anim_mode + "_" + anim_direction
	$AnimationPlayer.play(animation)
	
func RayCastAngleLoop():
	cast_line = $RayCast2D
	#print(move_direction - 90)
	cast_line.rotation_degrees = move_direction - 90
	
	
func PlaySoundFX(sound):
	$SoundFX.set_stream(sound)
	$SoundFX.play()
