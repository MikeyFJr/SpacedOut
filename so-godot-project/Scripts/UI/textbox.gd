extends CanvasLayer

const CHAR_READ_RATE = 0.03
const DEBUG = false

@onready var textbox_container = $TextContainer
@onready var label = $TextContainer/MarginContainer/Panel/HBoxContainer/Text
@onready var end_symbol = $TextContainer/MarginContainer/Panel/HBoxContainer/Continue

@onready var speaker_container = $SpeakerContainer
@onready var speaker_label = $SpeakerContainer/Panel/MarginContainer/Label

@onready var tween = get_tree().create_tween()

signal text_finished

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	if DEBUG: print("Stating State:State.READY")
	hide_textbox()
#	queuing text, but this can be done different function but good for now for testing
#all the queue needs is ["text","speaker name"]
	
	
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
				#get_tree().paused = true
			
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1.0
				tween.kill()
				end_symbol.text = "➤"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				if text_queue.is_empty():
					hide_textbox()
					emit_signal("text_finished")  # Only emit when all lines are done
				else:
					change_state(State.READY)
					#hide_textbox()

func hide_textbox():
	GlobalState.paused = false
	end_symbol.text=""
	label.text = ""
	#get_tree().paused = false
	textbox_container.hide()
	speaker_container.hide()
	

func queue_text(next_text):
	text_queue.push_back(next_text)

func show_textbox():
	GlobalState.paused = true
	textbox_container.show()
	speaker_container.show()

func display_text():
	if text_queue.is_empty():
		return  
	tween = get_tree().create_tween()
	var next = text_queue.pop_front()
	var next_text = next[0]
	var next_speak = next[1]
	
	label.text = next_text
	if DEBUG : print(label.text)
	speaker_label.text = next_speak
	label.visible_ratio = 0.0
	
	show_textbox()
	change_state(State.READING)
	tween.tween_property(label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE).from(0).finished
	tween.connect("finished", on_tween_finished)
	end_symbol.text = "..." 
	
func on_tween_finished():
	
	end_symbol.text = "➤"
	change_state(State.FINISHED)
	
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			if DEBUG:print("Changing state to: State.READY")
		State.READING:
			if DEBUG:print("Changing state to: State.READING")
		State.FINISHED:
			if DEBUG:print("Changing state to: State.FINISHED")
