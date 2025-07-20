extends Path
class_name PathBasic

@onready var left_1: Marker3D = $LeftSpawn/Left1
@onready var left_2: Marker3D = $LeftSpawn/Left2
@onready var right_1: Marker3D = $RightSpawn/Right1
@onready var right_2: Marker3D = $RightSpawn/Right2
@onready var trees: Node3D = $Trees
var all_trees : Array
var all_bushes : Array
var all : Array

var left_spawn_noise

var tree1 : PackedScene = preload("res://objects/trees/tree1.tscn")
var tree2 : PackedScene = preload("res://objects/trees/tree2.tscn")
var tree3 : PackedScene = preload("res://objects/trees/tree3.tscn")

var bush1 : PackedScene = preload("res://objects/bushes/bush_1.tscn")
var bush2 : PackedScene = preload("res://objects/bushes/bush_2.tscn")
var bush3 : PackedScene = preload("res://objects/bushes/bush_3.tscn")

func _ready():
	
	all_trees = [tree1, tree2, tree3]
	all_bushes = [bush1, bush2, bush3]
	all = all_trees + all_bushes

	#populate("tree", 50, left_1, left_2)
	#populate("tree", 50, right_1, right_2)
	poisson_disc_sampling_populate("any", 26, 2, left_1, left_2)
	poisson_disc_sampling_populate("any", 26, 2, right_1, right_2)

# func populate(type : String, amount : int, marker1 : Marker3D, marker2 : Marker3D):
# 	for i in amount:
# 		var new_object = get_random_of_type(type).instantiate()
# 		trees.add_child(new_object)
# 		new_object.global_position = get_random_point_in_zone(marker1, marker2)
# 		new_object.rotation.y = randi_range(0,360)

func get_random_point_in_zone(marker1 : Marker3D, marker2 : Marker3D) -> Vector3:
	var rando_x = randf_range(marker1.global_position.x, marker2.global_position.x)
	var rando_z = randf_range(marker1.global_position.z, marker2.global_position.z)
	return Vector3(rando_x, 0, rando_z)

func get_random_of_type(type : String) -> PackedScene:
	match type:
		"tree":
			return all_trees.pick_random()
		"bush":
			return all_bushes.pick_random()
		"any":
			return all.pick_random()

	return null

func poisson_disc_sampling_populate(type : String, amount : int, radius : float, marker1 : Marker3D, marker2 : Marker3D):
	var polygon = Polygon2D.new()
	polygon.polygon = [
		Vector2(marker1.global_position.x, marker1.global_position.z),
		Vector2(marker2.global_position.x, marker1.global_position.z),
		Vector2(marker2.global_position.x, marker2.global_position.z),
		Vector2(marker1.global_position.x, marker2.global_position.z)
	]
	var points = PoissonDiscSampling.generate_points_for_polygon(polygon.polygon, radius, amount)
	for point in points:
		var new_object = get_random_of_type(type).instantiate()
		trees.add_child(new_object)
		new_object.global_position = Vector3(point.x, 0, point.y)
		new_object.rotation.y = randi_range(0,360)
