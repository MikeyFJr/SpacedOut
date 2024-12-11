extends Control

#@export var w1 : TextureRect
#@export var w2 : TextureRect
#@export var w3 : TextureRect
#@export var w4 : TextureRect


@export var level_btn_1 : Button
@export var level_btn_2 : Button
@export var level_btn_3 : Button

@export var level_1 = "res://Scenes/Stages/World-1/W1_L1.tscn"
@export var level_2 = "res://Scenes/Stages/World-1/W1_L1.tscn"
@export var level_3 = "res://Scenes/Stages/World-1/W1_L1.tscn"

@export var level_1_name ="blahblah"
@export var level_2_name ="blahblah"
@export var level_3_name ="blahblah"

@export var go_btn : Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(level_2_name)
	if GlobalState.visited[level_1_name]["locked"]: level_btn_1.disabled = true
	if GlobalState.visited[level_2_name]["locked"]: level_btn_2.disabled = true
	if GlobalState.visited[level_3_name]["locked"]: level_btn_3.disabled = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_btn_1_pressed() -> void:
	get_tree().change_scene_to_file(level_1)


func _on_level_btn_2_pressed() -> void:
	get_tree().change_scene_to_file(level_2)


func _on_level_btn_3_pressed() -> void:
	get_tree().change_scene_to_file(level_3)


func _on_go_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/menu_planet_select.tscn")
