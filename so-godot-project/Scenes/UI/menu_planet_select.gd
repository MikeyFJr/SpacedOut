extends Control

@export var world_1_play : Button
@export var world_2_play : Button
@export var world_3_play : Button
@export var world_4_play : Button
@export var next_btn : Button

@export var world_label : Label



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# world 1 play button pressed function
func _on_button_w1_pressed() -> void:
	#Need to add variable and assignments that pass to global state that the current_world is World 1
	get_tree().change_scene_to_file("res://Scenes/UI/menu_lvl_select_new.tscn") # transition to the world 1 level select
	
func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/w2_level_select_scene.tscn") # transition to the world 1 level select

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/w3_level_select_scene.tscn") # transition to the world 1 level select


func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/w4_level_select_scene.tscn") # transition to the world 1 level select


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/menu_main.tscn") # transition to the world 1 level select
