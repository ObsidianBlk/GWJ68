extends Node2D
class_name ComponentShovel

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal diggable(can : bool)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("ComponentShovel")
@export var polygon : Polygon2D = null
@export var raycast : RayCast2D = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _diggable : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	if polygon != null:
		polygon.visible = false

func _physics_process(delta: float) -> void:
	if raycast != null:
		var colliding : bool = raycast.is_colliding()
		if _diggable != colliding:
			diggable.emit(colliding)
		_diggable = colliding


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func dig() -> void:
	if polygon == null: return
	if raycast != null:
		if not raycast.is_colliding():
			return
	var global_poly : Array[Vector2] = []
	for point : Vector2 in polygon.polygon:
		global_poly.append(
			global_transform * point
		)
	Relay.dig(PackedVector2Array(global_poly))

func can_dig() -> bool:
	if raycast == null: return false
	return raycast.is_colliding()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



