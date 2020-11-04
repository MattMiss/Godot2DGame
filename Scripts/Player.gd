extends KinematicBody2D


var anim_direction = "Down"
var anim_mode = "Idle"
var animation

var max_speed = 400
var speed = 0
var acceleration  = 1200
var move_direction = 90
var can_move = false
var moving = false
var destination = Vector2()
var movement  = Vector2() 
var next_attack_time = 0
var attack_cooldown_time = 1
var clicked = false
var cast_line

onready var canvas_anim_player = get_tree().root.get_node("Game/CanvasLayer/AnimationPlayer")
onready var battle_background = get_tree().root.get_node("Game/BattleBackground")


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
					get_tree().root.get_node("Game/CanvasLayer/AnimationPlayer").play("Sleep")
					yield(get_tree().create_timer(1), "timeout")
					return
				# NEW CODE - END
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time


	
	
func _process(_delta):
	
	if can_move:
		raycast_angle_loop()	
		animation_loop()
	
	
func _physics_process(delta):
	if can_move:
		if clicked:
			movement_loop(delta)
		else:
			direction_move_loop()
			movement = move_and_slide(movement)


func direction_move_loop():
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
	

func movement_loop(delta):
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


func animation_loop():
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
	
	
func combat_started(enemy_ref):
	can_move = false
	get_tree().paused = true
	canvas_anim_player.play("BattleTransition")
	yield(canvas_anim_player, "animation_finished")
	get_tree().root.get_node("Game/Desert").visible = false
	position.x = 0
	position.y = 0
	#battle_background.position.x = position.x
	#battle_background.position.y = position.y
	battle_background.visible = true
	enemy_ref.change_to_battle_size()
	enemy_ref.position.x = battle_background.get_node("EnemyPosition").position.x
	enemy_ref.position.y = battle_background.get_node("EnemyPosition").position.y
	visible = false
	get_tree().paused = false
	canvas_anim_player.play_backwards("BattleTransition")
	
	
func raycast_angle_loop():
	cast_line = $RayCast2D
	cast_line.rotation_degrees = move_direction - 90
	
	
	
func PlaySoundFX(sound):
	$SoundFX.set_stream(sound)
	$SoundFX.play()


func _on_PlayButton_pressed():
	#get_tree().root.get_node("Game/CanvasLayer/MenuBG").visible = false
	canvas_anim_player.play("MenuFade")
	yield(canvas_anim_player, "animation_finished")
	canvas_anim_player.play("WakeUp")
	yield(canvas_anim_player, "animation_finished")
	can_move = true


func _on_InteractArea_body_entered(body):
	if body.is_in_group("Interactable"):
		print(body.name)

