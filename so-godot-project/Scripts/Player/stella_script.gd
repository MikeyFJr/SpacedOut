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

var direction = 0

var input_buffer : Timer # Reference to the input queue timer
var coyote_timer : Timer # Reference to the coyote timer
var coyote_jump_available := true
var horizontal_input




#@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Set up input buffer timer
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)

	# Set up coyote timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)

func _physics_process(delta) -> void:
	#anim_player.play("idle")
	# Get inputs
	horizontal_input = Input.get_axis("move_left", "move_right")
	var jump_attempted := Input.is_action_just_pressed("jump")
	var boost_attempted :=Input.is_action_just_pressed("boost")

	# Add the gravity and handle jumping
	if jump_attempted or input_buffer.time_left > 0:
		if coyote_jump_available: # If jumping on the ground
			velocity.y = JUMP_VELOCITY
			coyote_jump_available = false
		elif is_on_wall() and horizontal_input != 0: # If jumping off a wall
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = WALL_JUMP_PUSHBACK * -sign(horizontal_input)
		elif jump_attempted: # Queue input buffer if jump was attempted
			input_buffer.start()
	
	if boost_attempted and GlobalState.boosts_available >0 :
		if DEBUG: print("Boost tried")
		velocity.y += BOOST_VELOCITY
		GlobalState.boosts_available -=1
		if DEBUG: print("Boosts available ",GlobalState.boosts_available)

	# Shorten jump if jump key is released
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	
	# Apply gravity and reset coyote jump
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y += get_gravity_now(horizontal_input) * delta

	# HYandle horizontal motion and friction
	var floor_damping := 1.0 if is_on_floor() else 0.5 # Set floor damping, friction is less when in air

	if horizontal_input and jump_attempted and not boost_attempted:
		velocity.x = (horizontal_input * SPEED/4) 
	elif horizontal_input:
		velocity.x = horizontal_input * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, (FRICTION * delta) * floor_damping)
	
#	cant tell which way I want to do it

	#if horizontal_input:
		#velocity.x = move_toward(velocity.x, horizontal_input * SPEED, ACCELERATION * delta)
	#else:
		#velocity.x = move_toward(velocity.x, 0, (FRICTION * delta) * floor_damping)

	# Apply velocity
	move_and_slide()

## Returns the gravity based on the state of the player
func get_gravity_now(input_dir : float = 0) -> float:
	if Input.is_action_pressed("fast_fall"):
		return FAST_FALL_GRAVITY
	if is_on_wall_only() and velocity.y > 0 and input_dir != 0:
		return WALL_GRAVITY
	return GRAVITY if velocity.y < 0 else FALL_GRAVITY

## Reset coyote jump
func coyote_timeout() -> void:
	coyote_jump_available = false
