extends Area3D

@onready var player: CharacterBody3D = $"../../Player"
@onready var path_machine: Node3D = $".."


@export var remover_offset : float = 128

func _process(delta: float) -> void:
	global_position = Vector3(0,0, player.global_position.z + remover_offset)

func _on_body_entered(body: Node3D) -> void:
	print(body.get_owner())
	if body.get_owner() is Path:
		body.get_owner().queue_free()
