extends Node2D

@onready var textbox = $Textbox 

func _ready():
	# For now queueing it all here
	textbox.queue_text(["And so we find ourselves at a new page","Narrator"])
	#textbox.queue_text(["Wait who are you?","Stella"])
	#textbox.queue_text(["Oop. And we continue....","Narrator"])
	textbox.show_textbox() 
	textbox.connect("text_finished", _on_text_finished)

func _on_text_finished():
	print("Text display complete!")
	get_tree().change_scene_to_file("res://Scenes/Stages/World-1/Level-1/main_w_1_l_1.tscn")


#not currently working but potientially could make it from a txt
#func load_dialogue_from_file(file_path: String) -> Array:
	#var dialogue_data = []
	#var file := File.new()
	#
	#if file.file_exists(file_path):
		#file.open(file_path, File.READ)
		#while not file.eof_reached():
			#var line = file.get_line()
			#var parts = line.split("|")
			#if parts.size() == 2:
				#dialogue_data.append(parts) # Each entry will be ["Text", "Speaker"]
		#file.close()
	#else:
		#print("Error: File not found at path:", file_path)
	#
	#return dialogue_data
