extends PopupDialog


var npc_name setget name_set
var dialogue setget dialogue_set
var answers setget answers_set
var npc

func name_set(new_value):
	npc_name = new_value
	$ColorRect/NPCName.text = new_value

func dialogue_set(new_value):
	dialogue = new_value
	$ColorRect/Dialogue.text = new_value

func answers_set(new_value):
	answers = new_value
	$ColorRect/Answers.text = new_value
	
	
func open():
	get_tree().paused = true
	popup()
	$AnimationPlayer.playback_speed = 60.0 / dialogue.length()
	$AnimationPlayer.play("ShowDialogue")
	
func close():
	get_tree().paused = false
	hide()

	
	
#func _ready():
	#set_process_input(false)
	
	
func _on_AnimationPlayer_animation_finished(_anim_name):
	set_process_input(true)


func _input(event):
	#print(event)
	if event.is_action_pressed('YesDialogue'):
		#set_process_input(false)
		npc.talk("Y")
	elif event.is_action_pressed('NoDialogue'):
		#set_process_input(false)
		npc.talk("N")
			
