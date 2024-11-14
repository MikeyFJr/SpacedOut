extends Control

@export var menu : NinePatchRect
@export var inventory : NinePatchRect

@export var description : NinePatchRect

@export var animation_player : AnimationPlayer
#i think menu would be the one loading in the information into the slots ?
enum STATE { MENU, INVENTORY }
var ui_state = STATE.MENU

func _input(event):
	if event.is_action_pressed("ui_cancel") and not animation_player.is_playing():
		match ui_state:
			STATE.INVENTORY:
				ui_state = STATE.MENU
				hide_and_show("inventory", "menu")
			STATE.MENU:
				if menu.visible == true:
					animation_player.play("hide_menu")
				else:
					animation_player.play("show_menu")

func set_description(item):
	#GlobalState.item_data[item]["dialogue"] - how it was accessed in diff script
	
	description.find_child("Name").text = item.title
	description.find_child("Description").text = item.description
	description.find_child("Icon").texture = item.icon
	
func hide_and_show(first : String, second : String):
	animation_player.play("hide_" + first)
	await animation_player.animation_finished
	animation_player.play("show_" + second)
 
 
func _on_inventory_pressed():
	ui_state = STATE.INVENTORY
	hide_and_show("menu", "inventory")
 
 
 
func _on_quit_pressed():
	get_tree().quit()
