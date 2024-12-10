extends Node2D

@onready var textbox = $Textbox 
@export var next_scene_path = "res://Scenes/Stages/World-1/Level-1/main_w_1_l_1.tscn"
#change this in the inspector NOT in this GD script. this is default and meant to be changed
@export var dialogue_queue : Array[Dictionary] = [
	{"text": "Whoa....", "speaker": "Stella"},
	{"text": "Where am I?", "speaker": "Stella"},
	{"text": "That one she'll find out soon enough", "speaker": "Narrator"},
	{"text": "Nothing to do but look around then.", "speaker": "Stella"},
	{"text": "Here we go.", "speaker": "Stella"},
	{"text": "Extra text", "speaker": "Stella"}
#	default to change
#difficult to add element with text, so i put 6 here, delete IN INSPECTOR what you dont need.
 
]
func queue_text():
	for line in dialogue_queue:
		textbox.queue_text([line["text"], line["speaker"]])

	
func _ready():
	# For now queueing it all here
	#textbox.queue_text(["And so we find ourselves at a new page","Narrator"])
	#textbox.queue_text(["Wait who are you?","Stella"])
	#textbox.queue_text(["Oop. And we continue....","Narrator"])
	queue_text()
	textbox.show_textbox() 
	textbox.connect("text_finished", _on_text_finished)

func _on_text_finished():
	print("Text display complete!")
	get_tree().change_scene_to_file(next_scene_path)
