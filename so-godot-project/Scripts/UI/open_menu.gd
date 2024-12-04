extends Control

@export var menu : NinePatchRect
@export var inventory : NinePatchRect

@export var description : NinePatchRect

@export var animation_player : AnimationPlayer
@export var world_container : VBoxContainer 

#weird.. yes... but it works...
@export var world1_panel_1 : PanelContainer
@export var world1_panel_2 : PanelContainer
@export var world2_panel_1 : PanelContainer
@export var world2_panel_2 : PanelContainer
@export var world3_panel_1 : PanelContainer
@export var world3_panel_2 : PanelContainer
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
					GlobalState.setPaused(false)
				else:
					animation_player.play("show_menu")
					GlobalState.setPaused(true)

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
	_update_inventory_ui();
	hide_and_show("menu", "inventory")
 
 
 
func _on_quit_pressed():
	get_tree().quit()
	

func _update_inventory_ui():
	# could set items here, need to change the global state items or import a list? of items already made
	
	##world1_panel_1.item = Items.test_item1
	world1_panel_1.update_panel_state()  # Update to show whether collected or not
#
	##world1_panel_2.item = Items.test_item2
	world1_panel_2.update_panel_state()
#
	## Set items for World2 Panels
	##world2_panel_1.item = Items.test_item3
	world2_panel_1.update_panel_state()
#
	#world2_panel_2.item = Items.test_item4
	world2_panel_2.update_panel_state()
	
#	still need to do rest of worlds, so far just 1 + 2


func _on_button_2_pressed() -> void:
	#pass # Replace with function body.
	#var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()
	GlobalState.setPaused(false)
