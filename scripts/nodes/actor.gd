extends CharacterBody2D
class_name Actor

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const DIRECTIONAL_THRESHOLD : float = 0.0001

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Actor")
@export var gravity : float = 100.0
@export var max_speed : float = 100.0
@export var deceleration : float = 200.0


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _direction : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = gravity
	
	if abs(_direction) < DIRECTIONAL_THRESHOLD:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
	else:
		velocity.x = _direction * max_speed
	move_and_slide()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func move(direction : float) -> void:
	_direction = direction

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



