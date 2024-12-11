extends HBoxContainer

@export var item : Item

@onready var item_image = $Item_Image
@onready var item_label = $Item_Label

var item_amount = 0
#var item = 
#for checking specific ....ugh

func _ready():
	update_counter()
		


func update_counter():
	if item_label == null:
		print("item_label is null!")
		return
	
		
	match item.title:
		"Jetpack":
			item_amount = GlobalState.boosts_available
		"Bubble Gun":
			item_amount = GlobalState.dashes_available
		"Hookshot":
			item_amount = GlobalState.grapples_available
		_:
			item_amount = -1
	
	if item_amount != null and item_amount > 0 and !GlobalState.is_item_collected(item):
		item_amount = 0
		
	if item_amount != -1 or null:
		item_label.text = str(item_amount)
	else:
		item_label.text = "∞"
			

func update_panel_state() -> void:
	if item != null:
		if GlobalState.is_item_collected(item):
			self.modulate = Color(1, 1, 1) 
		else:
			self.modulate = Color(0.5, 0.5, 0.5)  # greying it out
			#$Icon.texture = preload("res://path/to/locked_icon.png") 
