extends Node
class_name PathContainer

var path_scene : PackedScene
var spawn_chance : float
var length : float
var conditions : Array[String] = []

func fill(new_path_scene : PackedScene, new_spawn_chance : float, new_length : float, new_conditions : Array[String]):
	path_scene = new_path_scene
	spawn_chance = new_spawn_chance
	length = new_length
	conditions = new_conditions
