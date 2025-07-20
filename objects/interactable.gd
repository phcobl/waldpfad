extends Area3D

@export var dialogue_key = "test"
@export var talk_sound : AudioStream

var area_active = false

signal interaction

func _ready() -> void:
	interaction.connect(_on_interact)
	
func _on_interact():
	DialogueSignalBus.emit_signal("display_dialogue", dialogue_key, talk_sound)
