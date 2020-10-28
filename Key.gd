extends Sprite

var old_guy

func _ready():
	old_guy = get_tree().root.get_node("Root/Guy")


func _on_Key_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		old_guy.necklace_found = true
