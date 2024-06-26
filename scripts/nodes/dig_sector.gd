extends Node2D
class_name DigSector

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Dig Sector")
@export var map : TileMap = null:				set = set_map
@export var layer : int = 0:					set = set_layer
@export var quadrant_size : int = 8
@export var quadrant_type : Quadrant.PolyType = Quadrant.PolyType.POLYGON

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_map(m : TileMap) -> void:
	if m != map:
		map = m
		_UpdateMap()

func set_layer(l : int) -> void:
	if l >= 0 and l != layer:
		layer = l
		_UpdateMap()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	Relay.dig_requested.connect(carve)
	_UpdateMap()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateMap() -> void:
	for q : Node in get_children():
		if q is Quadrant:
			remove_child(q)
			q.queue_free()
	if map != null:
		for cell : Vector2i in map.get_used_cells(0):
			var pos : Vector2 = map.map_to_local(cell)
			var q : Quadrant = Quadrant.new()
			q.size = Vector2.ONE * quadrant_size
			q.polygon_type = quadrant_type
			q.position = pos
			add_child(q)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func carve(clip_poly : PackedVector2Array) -> void:
	for q : Node in get_children():
		if not q is Quadrant: continue
		q.carve(clip_poly)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



