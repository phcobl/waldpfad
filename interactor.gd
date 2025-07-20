extends RayCast3D

@onready var crosshair: TextureRect = $"../../../../UI/Crosshair"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && is_colliding():
		get_collider().emit_signal("interaction")
	if is_colliding():
		crosshair.scale = Vector2(4,4)
	else:
		crosshair.scale = Vector2(1,1)
