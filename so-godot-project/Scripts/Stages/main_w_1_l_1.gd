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

#also think can just be changed in properties per scene, keeping same script
#defaultly 5 each,
@export var level: String = "w1_s1"
@export var boosts: int = 5
@export var dashes: int = 5
@export var hooks: int = 2

@onready var exit_area = $Area_exit  
@onready var popup = $Textbox/"Level Complete"

func _ready():
#	setting the boosts and dashes to the number per scene/level (as when this scene restarts they are given back the same number)

	GlobalState.boosts_available = boosts
	GlobalState.dashes_available = dashes
	GlobalState.grapples_available = hooks
	
	if !popup:
		print("Level complete not found")
	if !exit_area:
		print("area exit not found")
	
	exit_area.connect("player_entered", _on_exit_area_entered)
		
	if !GlobalState.check_visited(level):
		textbox.show_textbox() 
		queue_text()
		textbox.connect("text_finished", _on_text_finished)
		GlobalState.set_visited(level)
	AudioController.play_game_music()
	
func _on_exit_area_entered():
	if popup:
		popup.show_popup()
		
func queue_text():
	for line in dialogue_queue:
		textbox.queue_text([line["text"], line["speaker"]])
		
func _on_text_finished():
	textbox.hide_textbox()
	
	
