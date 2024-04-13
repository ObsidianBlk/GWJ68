extends StaticBody2D
class_name Quadrant

# Code in this class is adapted and modified from...
# https://github.com/matterda/godot-destructible-terrain/blob/main/Quadrant.gd

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Quadrant")
@export var size : Vector2 = Vector2.ONE * 8

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_size(s : Vector2i) -> void:
	if s.x > 0 and s.y > 0:
		size = s
		_Reset()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_Reset()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _Reset() -> void:
	for poly : Node2D in get_children():
		if poly is QuadColPoly:
			poly.queue_free()
	var qp : QuadColPoly = QuadColPoly.new()
	qp.update_polygon(_DefaultPolygon())
	add_child(qp);

func _DefaultPolygon(use_global_position : bool = false) -> PackedVector2Array:
	var offset : Vector2 = global_position if use_global_position else Vector2.ZERO
	return PackedVector2Array([
		(Vector2(-0.5, -0.5) * size) + offset,
		(Vector2(0.5, -0.5) * size) + offset,
		(Vector2(0.5, 0.5) * size) + offset,
		(Vector2(-0.5, 0.5) * size) + offset
	])

func _AvgPosition(pos_arr : PackedVector2Array) -> Vector2:
	if pos_arr.size() <= 0: return Vector2.ZERO
	var sum : Vector2 = Vector2.ZERO
	for p : Vector2 in pos_arr:
		sum += p
	return sum / pos_arr.size()

func _IsHole(poly_a : PackedVector2Array, poly_b : PackedVector2Array) -> bool:
	return Geometry2D.is_polygon_clockwise(poly_a) or Geometry2D.is_polygon_clockwise(poly_b)

func _SplitPolys(clip_poly : PackedVector2Array) -> Array[PackedVector2Array]:
	var arr : Array[PackedVector2Array] = []
	var avg_x : float = _AvgPosition(clip_poly).x
	
	var left : PackedVector2Array = _DefaultPolygon(true)
	left[1] = Vector2(avg_x, left[1].y)
	left[2] = Vector2(avg_x, left[2].y)
	
	var right : PackedVector2Array = _DefaultPolygon(true)
	right[0] = Vector2(avg_x, right[0].y)
	right[3] = Vector2(avg_x, right[3].y)
	
	arr.append(Geometry2D.clip_polygons(left, clip_poly)[0])
	arr.append(Geometry2D.clip_polygons(right, clip_poly)[0])
	
	return arr

func _PolyWorldToLocal(poly : PackedVector2Array) -> PackedVector2Array:
	var gpos : Vector2 = global_position
	var arr : Array[Vector2] = []
	for point in poly:
		arr.append(point - gpos)
	return PackedVector2Array(arr)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func carve(clip_poly : PackedVector2Array) -> void:
	for cp : Node in get_children():
		if not cp is QuadColPoly: continue
		var clipped_polys : Array[PackedVector2Array] = Geometry2D.clip_polygons(cp.world_polygon, clip_poly)
		var n_clipped : int = clipped_polys.size()
		match n_clipped:
			0: # Total overlap
				cp.queue_free()
			1: # Clip only resulted in a single polygon...
				cp.world_polygon = clipped_polys[0]
			_:
				if n_clipped == 2 and _IsHole(clipped_polys[0], clipped_polys[1]):
					for p : PackedVector2Array in _SplitPolys(clip_poly):
						var ncp : QuadColPoly = QuadColPoly.new()
						ncp.update_polygon(_PolyWorldToLocal(Geometry2D.intersect_polygons(p, cp.world_polygon)[0]))
						add_child(ncp)
					cp.queue_free()
				else:
					cp.world_polygon = clipped_polys[0]
					for i in range(n_clipped - 1):
						var ncp : QuadColPoly = QuadColPoly.new()
						ncp.update_polygon(_PolyWorldToLocal(clipped_polys[i + 1]))
						add_child(ncp)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



