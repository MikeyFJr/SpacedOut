extends Button

func _pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/menu_cutscene.tscn")
#	changes to textbox to show a working textbox. change it back to the other one 
#for the first scene
#	changing once we have a real menu screen with planet select + other
#"res://Scenes/Stages/World-1/Level-1/main_w_1_l_1.tscn"
#"res://Scenes/UI/textbox.tscn"
