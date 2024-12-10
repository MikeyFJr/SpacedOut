extends CanvasLayer


@export var next_level_path = "res://Scenes/Stages/World-1/Level-1/scene_template.tscn" #default
@export var level_select_path = "res://Scenes/UI/menu_lvl_select_new.tscn" #default

func show_popup():
	visible = true  

func hide_popup():
	visible = false  
	


func _on_button_pressed() -> void:
#	next level button
	#pass # Replace with function body.
	GlobalState.next_level(next_level_path)


func _on_button_2_pressed() -> void:
#	leve select button
	#pass # Replace with function body.
	GlobalState.next_level(level_select_path)
