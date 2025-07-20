extends CharacterBody3D

var speed
const WALK_SPEED = 1.0
#const SPRINT_SPEED = 2.4
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.0025

# Head bob
var bob_freq
var bob_amp
const SPRINT_BOB_FREQ = 8.0
const WALK_BOB_FREQ = 10.0
const SPRINT_BOB_AMP = 0.06
const WALK_BOB_AMP = 0.03
var t_bob = 0.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	

func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-75), deg_to_rad(75))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
		bob_freq = SPRINT_BOB_FREQ
		bob_amp = SPRINT_BOB_AMP
	else:
		speed = WALK_SPEED
		bob_freq = WALK_BOB_FREQ
		bob_amp = WALK_BOB_AMP

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * WALK_BOB_FREQ / 2) * WALK_BOB_AMP
	return pos
