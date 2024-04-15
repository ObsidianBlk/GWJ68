extends Node
class_name FiniteStateMachine

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal state_changed(state_name : StringName)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Finite State Machine")
@export var initial_state : FiniteState = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _initialized : bool = false
var _active_state : FiniteState = null

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
	if _active_state != null:
		_active_state.process_frame(delta)

func _physics_process(delta: float) -> void:
	if _active_state != null:
		_active_state.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	if _active_state != null:
		_active_state.process_input(event)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func init(parent : Actor) -> void:
	if _initialized or initial_state == null : return
	_initialized = true
	for child in get_children():
		if not child is FiniteState: continue
		child.init(parent)
	change_state(initial_state)
	_initialized = _active_state != null

func change_state(state : FiniteState) -> void:
	if _active_state == state: return # Already the active state.
	if _active_state != null:
		_active_state.exit()
	_active_state = state
	if _active_state != null:
		_active_state.enter()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



