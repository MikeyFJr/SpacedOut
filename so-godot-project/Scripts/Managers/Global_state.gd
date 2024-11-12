extends Node
#Global to hold boosts, tracking item pickup, etc

var boosts_available = 10
var dialogue_active = false #used to "pause" movement while dialogue happening
							#since get tree pause() will stop music 

#tracking item pickup 
#were using array of items with predefined enum of them so we dont accidentally do it twice.
#This also means defining them here first
enum Items{
	test_item1,
	test_item2,
	test_item3,
}
#items description + dialogue that can be pulled on pickup and menu to see items

#the description would not be said, but read in the menu 
var item_data = {
	Items.test_item1: { 
		"description": "An ancient scroll with unreadable text.", 
		"dialogue": [
			"I found an old scroll!",
			"The symbols on it look strange...",
			"Maybe someone can translate this."
		] 
	},
	Items.test_item2: { 
		"description": "A small, shiny gem.", 
		"dialogue": [
			"This gem looks valuable!",
			"It feels warm to the touch."
		]
	},
	Items.test_item3: { 
		"description": "A mysterious, locked box.", 
		"dialogue": [
			"Wonder what's inside this box?",
			"I need to find a way to open it."
		]
	}
}
var collected_items = []
