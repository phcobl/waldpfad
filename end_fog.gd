extends Node3D

@onready var front_fog: FogVolume = $FrontFog
@onready var back_fog: FogVolume = $BackFog

@onready var player: CharacterBody3D = $"../Player"

@export var distance : float = 10
var back_fog_min_distance : float

func _ready() -> void:
	back_fog_min_distance = player.global_position.z + distance
	back_fog.global_position = Vector3(0,0, player.global_position.z + distance)

# Keep front fog at same distance
# Keep back fog at same distance but don't let it go back
func _process(delta: float) -> void:
	front_fog.global_position = Vector3(0,0, player.global_position.z - distance * 5)
	var new_z = player.global_position.z + distance
	if new_z < back_fog.global_position.z:
		back_fog.global_position = Vector3(0,0, new_z)
