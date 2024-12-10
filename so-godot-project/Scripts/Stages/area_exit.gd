extends Area2D


@export var destination_scene_path = "res://Scenes/NextScene.tscn"
#could also add like functions to meet requirements for it to be open, but its fine for now
signal player_entered

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		#GlobalState.next_level(destination_scene_path)
		#get_tree().call_group("leaving_area",)
		emit_signal("player_entered")
