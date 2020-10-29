extends StaticBody2D

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
enum Potion { HEALTH, MANA }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var necklace_found = false
var anim_player
var dialoguePopup
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player = get_node("AnimationPlayer")
	anim_player.play("Idle")
	dialoguePopup = get_tree().root.get_node("Root/CanvasLayer/DialoguePopup")
	player = get_tree().root.get_node("Root/Player")




func talk(answer = ""):
	# Set Fiona's animation to "talk"
	anim_player.play("Talk")
	
	# Set dialoguePopup npc to Guy
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Old Guy"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					print("matched")
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Hello adventurer! I lost my necklace, can you find it for me?"
					dialoguePopup.answers = "[Y] Yes  [N] No"
					dialoguePopup.open()
				1:
					match answer:
						"Y":
							# Update dialogue tree state
							dialogue_state = 2
							# Show dialogue popup
							dialoguePopup.dialogue = "Thank you!"
							dialoguePopup.answers = "[Y] Bye"
							dialoguePopup.open()
						"N":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "If you change your mind, you'll find me here."
							dialoguePopup.answers = "[Y] Bye"
							dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					anim_player.play("Idle")
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					anim_player.play("Idle")
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Did you find my necklace?"
					if necklace_found:
						dialoguePopup.answers = "[Y] Yes  [N] No"
					else:
						dialoguePopup.answers = "[N] No"
					dialoguePopup.open()
				1:
					if necklace_found and answer == "Y":
						anim_player.play("Celebrate")
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.dialogue = "You're my hero! Please take this potion as a sign of my gratitude!"
						dialoguePopup.answers = "[Y] Thanks"
						dialoguePopup.open()
					else:
						# Update dialogue tree state
						dialogue_state = 3
						# Show dialogue popup
						dialoguePopup.dialogue = "Please, find it!"
						dialoguePopup.answers = "[Y] I will!"
						dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					anim_player.play("Idle")
					# Add potion and XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
				
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					anim_player.play("Idle")
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Thanks again for your help!"
					dialoguePopup.answers = "[Y] Bye"
					dialoguePopup.open()
				1:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					anim_player.play("Idle")
