extends Node3D

@onready var existing_paths: Node3D = $ExistingPaths
@onready var player: CharacterBody3D = $"../Player"

@onready var first_element: Node3D = $ExistingPaths/PathElement
var last_path_length = 16 # Used as offset to spawn new paths. Basic path length is 16.

# The latest instantiated path
var front_path

# Paths
var path_basic : PathContainer

# Queue of all paths that should spawn
var path_queue : Array[PathContainer]= []

const MAX_EXISTING_PATHS : int = 3 # How many paths are spawned in front of the player
const SPECIAL_ELEMENT_BUFFER : int = 6 # How man basic elements are added after each special path

func _ready() -> void:
	path_basic = PathContainer.new()
	path_basic.fill(preload("res://path_element.tscn"), 1.00, 16, ["basic"])
	front_path = first_element

# Spawn missing paths
func _process(delta: float) -> void:
	if existing_paths.get_children().size() <= MAX_EXISTING_PATHS:
		if !path_queue.is_empty():
			spawn_path(get_next_path_in_queue())
		else:
			spawn_path(path_basic)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_action"):
		path_queue.append(AllPathElements.give_elements_with_condition("none")[0])

func get_next_path_in_queue() -> PathContainer:
	var path_first = path_queue[0]
	path_queue.pop_front()
	return path_first

func spawn_path(element : PathContainer):
	var new_path = element.path_scene.instantiate()
	existing_paths.add_child(new_path)
	new_path.global_position = front_path.global_position + Vector3(0,0,-last_path_length)
	last_path_length = element.length
	front_path = new_path

func add_special_element_to_queue(new_element : PathContainer):
	path_queue.append(new_element)
	for i in SPECIAL_ELEMENT_BUFFER:
		path_queue.append(path_basic)
