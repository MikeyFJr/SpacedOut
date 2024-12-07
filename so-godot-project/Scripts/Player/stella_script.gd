extends CharacterBody2D
class_name PlayerController

#copied from previous 

const DEBUG = true

#const SPEED = 300.0 
#const ACCELERATION = 1000.0 
#const FRICTION = 1700.0 
#const GRAVITY = 2000.0 
#const FALL_GRAVITY = 3000.0 
#const FAST_FALL_GRAVITY = 5000.0 
#const WALL_GRAVITY = 25.0
#const JUMP_VELOCITY = -500.0
#const WALL_JUMP_VELOCITY = -700.0 
#const WALL_JUMP_PUSHBACK = 300.0 
#const INPUT_BUFFER_PATIENCE = 0.1 
#const COYOTE_TIME = 0.08 

const SPEED = 200.0 # Base horizontal movement speed
const ACCELERATION = 700.0 # Base acceleration
const FRICTION = 1700.0 # Base friction
const GRAVITY = 2000.0 # Gravity when moving upwards
const FALL_GRAVITY = 3000.0 # Gravity when falling downwards
const FAST_FALL_GRAVITY = 5000.0 # Gravity while holding "fast_fall"
const WALL_GRAVITY = 25.0 # Gravity while sliding on a wall
const JUMP_VELOCITY = -450.0 # Maximum jump strength
const WALL_JUMP_VELOCITY = -300.0 # Maximum wall jump strength
const WALL_JUMP_PUSHBACK = 300.0 # Horizontal push strength off walls
const INPUT_BUFFER_PATIENCE = 0.1 # Input queue patience time
const COYOTE_TIME = 0.08 # Coyote patience time

const BOOST_VELOCITY = -800.0 # strength for boost
const DASH_VELOCITY = 800.0 # strength for dash

var direction = 0
var facing_right = true

var input_buffer : Timer # Reference to the input queue timer
var coyote_timer : Timer # Reference to the coyote timer
var coyote_jump_available := true
var horizontal_input

var is_dashing = false
const DASH_SPEED = 2
var can_dash = true

@onready var dash_duration_timer = $DashDurationTimer

#death duration
@onready var death_timer = Timer.new()


#@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Set up input buffer timer
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)
	
	#Setting up timer for death.
	death_timer.wait_time = .5  
	death_timer.one_shot = true
	death_timer.connect("timeout",_on_death_timeout)
	add_child(death_timer)
	
	# Set up coyote timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

func is_player() -> bool:
	return true
	
func _physics_process(delta) -> void:
	# Get inputs
	#print("velocity:",velocity.y)
	if GlobalState.paused:
		return
		
	if horizontal_input == -1:
		facing_right = false
		GlobalState.stella_direction = -1
	elif horizontal_input == 1:
		facing_right = true
		GlobalState.stella_direction = 1
		
	horizontal_input = Input.get_axis("move_left", "move_right")
	var jump_attempted := Input.is_action_just_pressed("jump")
	var boost_attempted := Input.is_action_just_pressed("boost") 
	var dash_attempted = (Input.is_action_just_pressed("dash"))
	var grapple_attempted = Input.is_action_just_pressed("grapple")

	# Boost Jump (Up + Boost)
	if boost_attempted and GlobalState.boosts_available > 0 :
		if DEBUG: print("Boost jump triggered")
		velocity.y = BOOST_VELOCITY
		GlobalState.boosts_available -= 1
		if DEBUG: print("Boosts available ", GlobalState.boosts_available)

	# Dash
	elif dash_attempted and GlobalState.dashes_available > 0:
#		can dash could be used to limit the amt of times dashed, but i think we are going to limit that
#		with an actual number, so maybe a puzzle requires you to use two dashes at once?
#add in a global var for number of dashes
		is_dashing = true
		#can_dash = false
		direction = sign(horizontal_input)
		#velocity.x = DASH_VELOCITY
		dash_duration_timer.start()
		GlobalState.dashes_available -= 1
		if DEBUG: print("Dash triggered, Dashes available ",GlobalState.dashes_available)
		
	# Grappling Hook
	elif grapple_attempted and GlobalState.grapples_available > 0:
		var Hookshot = preload("res://Scenes/Items/Hookshot.tscn").instantiate()
		add_child(Hookshot)
		if facing_right:
			Hookshot.transform = $Marker2DR.transform # Currently only shoots to the right, make this flip with Stella
		elif not facing_right:
			Hookshot.transform = $Marker2DL.transform
		GlobalState.grapples_available -= 1
		if DEBUG: print("Grapple shot, shots availale: ", GlobalState.grapples_available)
		

	# Apply jump or buffered jump
	if jump_attempted or input_buffer.time_left > 0:
		if is_on_floor() or coyote_jump_available:
			velocity.y = -450.0
			coyote_jump_available = false
		elif is_on_wall() and horizontal_input != 0:
			velocity.y = -300.0
			velocity.x = 300.0 * -sign(horizontal_input)
		elif jump_attempted:
			input_buffer.start()

	# Gravity and floor reset
	if is_on_floor():
		coyote_jump_available = true
		#can_dash = true 
		coyote_timer.stop()
	elif not is_dashing:
		velocity.y += get_gravity_now() * delta
		if coyote_jump_available and coyote_timer.is_stopped():
			coyote_timer.start()

	# Apply horizontal movement, only if not dashing
	if is_dashing:
		velocity.x = direction * SPEED * DASH_SPEED
	else:
		if horizontal_input:
			velocity.x = horizontal_input * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 1700.0 * delta)

	# Apply velocity
	move_and_slide()

# Returns the gravity based on the state of the player
func get_gravity_now(input_dir : float = 0) -> float:
	if Input.is_action_pressed("fast_fall"):
		return FAST_FALL_GRAVITY
	if is_on_wall_only() and velocity.y > 0 and input_dir != 0:
		return WALL_GRAVITY
	return GRAVITY if velocity.y < 0 else FALL_GRAVITY
	

# Reset coyote jump
func coyote_timeout() -> void:
	coyote_jump_available = false


#duration for how long dash is
func _on_dash_duration_timer_timeout() -> void:
	is_dashing = false
	dash_duration_timer.stop()

func _on_death_timeout():
	# Reset modulate (optional, since the scene restarts
	modulate = Color(1, 1, 1)  #setting her color back to normal
	GlobalState.paused = false
	GlobalState.on_death()
	
#for obstacles, how were handling that
func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	#	death
	GlobalState.paused = true
	modulate = Color(1, 0, 0)  # Change the character to red
	death_timer.start()        # Start the death timer
