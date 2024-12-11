extends CanvasLayer


@onready var grapplingHook = $PanelContainer/MarginContainer/GridContainer/VBoxContainer/GrapplingHook
@onready var lavaBoots = $PanelContainer/MarginContainer/GridContainer/VBoxContainer/LavaBoots
@onready var bubbleGun = $PanelContainer/MarginContainer/GridContainer/VBoxContainer/BubbleGun
@onready var jetPack = $PanelContainer/MarginContainer/GridContainer/VBoxContainer/Jetpack

func _ready():
	GlobalState.connect("ability_updated",_on_ability_updated)
	_update_hud()

func _update_hud() -> void:
	grapplingHook.update_counter()
	bubbleGun.update_counter()
	jetPack.update_counter()

func _on_ability_updated(ability_name: String) -> void:
	match ability_name:
		"Hookshot":
			grapplingHook.update_counter()
		"Bubble Gun":
			bubbleGun.update_counter()
		"Jetpack":
			jetPack.update_counter()
		_:
			_update_hud()
