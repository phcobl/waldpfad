extends Node2D

var points : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var polygon_points = $Polygon2D.polygon
	points = PoissonDiscSampling.generate_points_for_polygon(polygon_points, 20, 30)