extends Node
#Global to hold boosts, tracking item pickup, etc

var boosts_available: set = _set_boosts_available, get = _get_boosts
var dashes_available: set = _set_dashes_available, get = _get_dashes
var grapples_available: set = _set_grapples_available, get= _get_grapples


var floats_available = 10 # Lava Boots
var beams_available = 10 # Restoration Beam
#vary hard coded.....
var  lava_boots = false
var grappling = false # Detects if Stella is travelling on the grappling hook
var grapple_shot = false # Limits Stella to one grappling hook at a time

var stella_direction = 1
#maybe this can be changed at the begginning of each level calling it?
var paused = false #used to "pause" movement while dialogue happening
							#since get tree pause() will stop music and i believe process
							
func new_item_collected():
	emit_signal("ability_updated","gen")
	
func _set_boosts_available(value: int) -> void:
	boosts_available = value
	emit_signal("ability_updated", "Jetpack")
	
func _set_dashes_available(value: int) -> void:
	dashes_available = value
	emit_signal("ability_updated", "Bubble Gun")

func _set_grapples_available(value: int) -> void:
	grapples_available = value
	emit_signal("ability_updated", "Hookshot")
	
func _get_boosts():
	return boosts_available
func _get_dashes():
	return dashes_available
func _get_grapples():
	return grapples_available
func setPaused(pause):
	paused = pause
	AudioController.set_paused(pause) 

var DEBUG = true

signal ability_updated(ability_name: String)

var collected_items = []
#boots would be collected into collected items as 
#VERY hard coded but boots are <Resource#-9223371975802485477> 

func is_item_collected(item: Item) -> bool:
	return item in collected_items

var visited = {
	"w1_s1":false,
	"w1_s2":false,
	"w1_s3":false,
	"w2_s1":false,
	"w2_s2":false,
	"w2_s3":false,
	"w3_s1":false,
	"w3_s2":false,
	"w3_s3":false,
	"w4_s1":false,
	"w4_s2":false,
	"w4_s3":false,
	}  #visited bools. used for seeing intros and not seeing them again
#	could also be used in a menu of some sort to know if you have visited that planet/scene

func next_level(path):
	get_tree().change_scene_to_file(path)
	print("Changing scene")

func set_visited(level):
	if level in visited and visited[level] == false:
		visited[level] = true
		if DEBUG: print("set",level,"to true")
	else:
		if DEBUG: print("level not found or error")

func check_visited(level):
	return visited[level] == true
	
func on_death():
#	if we decide to make it having a "life" system that should be easy enough, for now one hit and it restarts the level
#it would be here and dealing with a "global" lifes that would be updated by the scene
	#var current_scene = get_tree().current_scene
#	maybe could use current scene to retrace to a difference scene but mentally easier to add export if wanted x amt lives in seperate room before going back to "main" room	
	get_tree().reload_current_scene()
	
