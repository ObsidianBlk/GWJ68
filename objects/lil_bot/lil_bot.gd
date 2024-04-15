extends Actor
class_name LilBot

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("LilBot")
@export var initial_direction : Actor.DIRECTION = Actor.DIRECTION.Left
@export var flip_h : bool:					set=set_flip_h,get=get_flip_h
@export var flip_v : bool:					set=set_flip_v,get=get_flip_v

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _flipped_h : bool = false
var _flipped_v : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _viz: Node2D = %Viz


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_flip_h(f : bool) -> void:
	_flipped_h = f
	_UpdateFlip()

func get_flip_h() -> bool:
	return _flipped_h

func set_flip_v(f : bool) -> void:
	_flipped_v = f
	_UpdateFlip()

func get_flip_v() -> bool:
	return _flipped_v

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateFlip() -> void:
	if _viz == null: return
	_viz.scale = Vector2(
		-1.0 if _flipped_h else 1.0,
		-1.0 if _flipped_v else 1.0
	)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



