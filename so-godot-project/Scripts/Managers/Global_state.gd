extends Node
#Global to hold boosts, tracking item pickup, etc

var boosts_available = 10 # Jetpack
var dashes_available = 10 # Bubble Gun
var grapples_available = 10 # Grappling Hook
var floats_available = 10 # Lava Boots
var beams_available = 10 # Restoration Beam
#vary hard coded.....
var  lava_boots = false


var stella_direction = 1
#maybe this can be changed at the begginning of each level calling it?
var paused = false #used to "pause" movement while dialogue happening
							#since get tree pause() will stop music and i believe process.
func setPaused(pause):
	paused = pause
	AudioController.set_paused(pause) 

var DEBUG = true
#tracking item pickup 
#were using array of items with predefined enum of them so we dont accidentally do it twice.
#This also means defining them here first
#it probably would be better a different way, but this works and i am still learning it..
#enum Items{
	#test_item1,
	#test_item2,
	#test_item3,
#}
#items description + dialogue that can be pulled on pickup and menu to see items

#the description would not be said, but read in the menu 
#var item_data = {
	#Items.test_item1: { 
		#"description": "An ancient scroll with unreadable text.", 
		#"dialogue": [
			#"I found an old scroll!",
			#"The symbols on it look strange...",
			#"Maybe someone can translate this."
		#] 
	#},
	#Items.test_item2: { 
		#"description": "A small, shiny gem.", 
		#"dialogue": [
			#"This gem looks valuable!",
			#"It feels warm to the touch."
		#]
	#},
	#Items.test_item3: { 
		#"description": "A mysterious, locked box.", 
		#"dialogue": [
			#"Wonder what's inside this box?",
			#"I need to find a way to open it."
		#]
	#}
#}



#knowing what world it should be found in. In a seperate part so those can be accessed by themselves
#var world_items = {
	#"world_1": [Items.test_item1, Items.test_item2],
	#"world_2": [Items.test_item3],
	#"world_3": []
#}
#i changed a bit, most of the above might not be needed anymore, but maybe a seperate file for items

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
	
