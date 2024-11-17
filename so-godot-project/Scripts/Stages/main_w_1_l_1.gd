extends Node2D
@onready var textbox = $Textbox 

@export var dialogue_queue : Array[Dictionary] = [
	{"text": "Whoa....", "speaker": "Stella"},
	{"text": "Where am I?", "speaker": "Stella"},
	{"text": "That one she'll find out soon enough", "speaker": "Narrator"},
	{"text": "Nothing to do but look around then.", "speaker": "Stella"},
	{"text": "Here we go.", "speaker": "Stella"}
]
#defaultly set to what first scene has, change it on the properties per scene


@export var level: String = "w1_s1"

func _ready():
	if !GlobalState.check_visited(level):
		textbox.show_textbox() 
		queue_text()
		textbox.connect("text_finished", _on_text_finished)
		GlobalState.set_visited(level)
	AudioController.play_game_music()
	
	
func queue_text():
	for line in dialogue_queue:
		textbox.queue_text([line["text"], line["speaker"]])
		
func _on_text_finished():
	textbox.hide_textbox()
	
	
