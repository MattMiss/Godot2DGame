extends Node2D

var indoor_audio
var outdoor_audio
var animation_player

func _ready():
	indoor_audio = get_tree().root.get_node("Game/IndoorMusic")
	outdoor_audio = get_tree().root.get_node("Game/OutdoorMusic")
	animation_player = get_tree().root.get_node("Game/CanvasLayer/AnimationPlayer")
	

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$home_roof.hide()
		indoor_audio.set_stream_paused(false)
		outdoor_audio.set_stream_paused(true)
		#animation_player.play("OutdoorMusicFadeOut")
		#animation_player.play("IndoorMusicFadeIn")

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		$home_roof.show()
		indoor_audio.set_stream_paused(true)
		outdoor_audio.set_stream_paused(false)
		#get_tree().root.get_node("Root/OutdoorMusic").set_stream_paused(false)
		#get_tree().root.get_node("Root/CanvasLayer/AnimationPlayer").play("OutdoorMusicFadeIn")


func _on_SaveArea_body_entered(body):
	pass # Replace with function body.
