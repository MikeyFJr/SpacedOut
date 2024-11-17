
#Collectable item
#using GlobalState collected items
#currently 


#has a collisionShape 2d, so would need to know when interacted with (for now walking into)
#once it has collided, with a collison mask (need to set the layer for it) on player...
#then it will add it to global state array and then call the textbox that is in that scene with the collectable item
#to add text about what she collected
extends Area2D

# Signals
signal item_collected(item_description)
var DEBUG = false

@export var item : Item

@onready var textbox = %Textbox
@onready var sprite = $Sprite2D  # the sprite 2d node im gonna change with the item texture

func _ready():
	if item in GlobalState.collected_items:
		queue_free()
		
	connect("body_entered", _on_body_entered)
	print("Texture :", sprite.texture)
	if item:
		sprite.texture = item.icon 
		print("Texture assigned:", sprite.texture)
	else:
		print("Item not inserted")
		
#	making sure textbox exists
	if not textbox:
		print("textbox not found")
		textbox = get_tree().get_root().get_node("./Textbox")  # Example path

func _on_body_entered(body):
	if body.is_player():
		collect_item()

func collect_item():
	if item not in GlobalState.collected_items:
		GlobalState.collected_items.append(item)
		# signal for collected item (so we could maybe use in hud when we do that ig)
		#var dialogue_lines = GlobalState.item_data[item]["dialogue"]
		emit_signal("item_collected")
		queue_free() #remove it from scene after collection
		
		if textbox:
			for line in item.dialogue:
				textbox.queue_text([line, "Stella"])  # adding each line from global_state(has the items and dialogue for each item)
			textbox.show_textbox()
			textbox.connect("text_finished", _on_text_finished)

func _on_text_finished():
	if textbox:
		textbox.hide_textbox()
