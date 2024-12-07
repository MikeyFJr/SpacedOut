extends Area2D


var speed = 500
var maxlength = 50 # Amount of time the grappling hook will for before retracting back to Stella.
var length = 0 # Current point of the path of the grappling hook.
var fired = false # Checks if hookshot was fired
const DEBUG = true
var grapple_shot = Input.is_action_just_pressed("grapple")
var horizontal_input = Input.get_axis("move_left", "move_right")
var facing_right = true
var direction = 0
var hit = false # Checks if hookshot has hit a wall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalState.stella_direction == -1:
		facing_right = false
	elif GlobalState.stella_direction == 1:
		facing_right = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grapple_shot and length == 0: # Retraction Check
		if DEBUG: print("Hookshot travelling")
		fired = true
	elif grapple_shot and length == (maxlength / 2):
		if DEBUG: print("Hookshot retracting")
	elif grapple_shot and length == maxlength:
		if DEBUG: print ("Hookshot didn't hit anything")
		GlobalState.grapple_shot = false
		queue_free()
	
	if horizontal_input == -1:
		facing_right = false
	if horizontal_input == 1:
		facing_right = true
		
	if facing_right:
		direction = 1
		$Sprite2D.flip_h = false
	elif not facing_right:
		direction = -1
		$Sprite2D.flip_h = true
	
	if fired and length < (maxlength / 2) and not hit: # Travel
		position += transform.x * speed * delta * direction
		length += 1
	elif fired and length >= (maxlength / 2) and length <= maxlength and not hit:
		position -= transform.x * speed * delta * direction
		length += 1
	
	if fired and hit: # "Freeze" in place
		position -= transform.x * speed * delta * direction
	
	if not GlobalState.grapple_shot: # Stops the hookshot if Stella jumps early
		queue_free()
		
	pass
	
	
	


func _on_body_entered(body: Node2D) -> void:
	if body.has_meta("Grappleable") and fired: # Check if object shot is a platform the grappling hook latches onto
		if DEBUG: print("Wall Hit")	 
		speed = 300
		hit = true
		GlobalState.grappling = true 
	if body.has_meta("Stella") and GlobalState.grappling:
		GlobalState.grappling = false
		GlobalState.grapple_shot = false
		queue_free()
	pass # Replace with function body.
