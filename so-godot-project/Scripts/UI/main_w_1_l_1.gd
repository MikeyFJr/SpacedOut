extends Node2D
@onready var textbox = $Textbox 

func _ready():
	AudioController.play_game_music()
	textbox.queue_text(["Whoa....","Stella"])
	textbox.queue_text(["Where am I?","Stella"])
	textbox.queue_text(["That one she'll find out soon enough","Narrator"])
	textbox.queue_text(["Nothing to do but look around then.","Stella"])
	textbox.queue_text(["Here we go.","Stella"])
	textbox.show_textbox() 
	textbox.connect("text_finished", _on_text_finished)

func _on_text_finished():
	textbox.hide_textbox()
