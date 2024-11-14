extends PanelContainer

@export var item : Item:
	set(value):
		item = value
		$Icon.texture = item.icon

var found = false; #if false, we dont show any information on it
		
func _on_mouse_entered() -> void:
	if item != null and found:
		owner.set_description(item)

# updating panel called when inventory called
func update_panel_state() -> void:
	if item != null:
		if GlobalState.is_item_collected(item):
			found = true;
			self.modulate = Color(1, 1, 1) 
		else:
			
			self.modulate = Color(0.5, 0.5, 0.5)  # greying it out
			#$Icon.texture = preload("res://path/to/locked_icon.png")  # could change it to a different texture
