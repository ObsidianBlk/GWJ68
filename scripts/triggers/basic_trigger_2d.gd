extends Node2D
class_name BasicTrigger2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal state_changed(on : bool)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Basic Trigger 2D")
@export var once : bool = false

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _state : bool = false
var _triggered : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _EmitStateChange() -> void:
	state_changed.emit(_state)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func trigger(on : bool) -> void:
	if _triggered or _state == on: return
	_state = on
	_EmitStateChange.call_deferred()
	if once and _state:
		_triggered = true

func is_active() -> bool:
	return _state

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



