extends Sprite

export(AudioStream) var CollectSound

var old_guy
var player
var player_sound_fx

func _ready():
	old_guy = get_tree().root.get_node("Root/Guy")
	player = get_tree().root.get_node("Root/Player")
	


func _on_Key_body_entered(body):
	if body.name == "Player":
		player_sound_fx = player.get_node("SoundFX")
		
		var stream = load("res://Sounds/coin_sound.tres")
		
		player.PlaySoundFX(stream)
		get_tree().queue_delete(self)
		old_guy.necklace_found = true
