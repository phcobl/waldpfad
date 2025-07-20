extends Node

var elements = []

func _ready() -> void:
	add_element(preload("res://path_debug.tscn"), 0.05, 2, ["none"])
	
func add_element(path_scene : PackedScene, spawn_chance : float, length : float, conditions : Array[String]):
	var new_element : PathContainer = PathContainer.new()
	new_element.fill(path_scene, spawn_chance, length, conditions)
	elements.append(new_element)

func give_elements_with_condition(condition):
	var elements_with_condition = []
	for element in elements:
		if element.conditions.has(condition):
			elements_with_condition.append(element)
	return elements_with_condition
