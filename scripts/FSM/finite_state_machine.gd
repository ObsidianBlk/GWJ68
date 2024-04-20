extends Node
class_name FiniteStateMachine

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal state_changed(state_name : StringName)
signal action_state_changed(state_name : StringName)

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
var _states : Dictionary = {}
var _action_state : FiniteState = null
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
	if not _states.is_empty() or initial_state == null : return
	for child in get_children():
		if not child is FiniteState: continue
		child.state_transition_requested.connect(change_state)
		child.action_transition_requested.connect(change_to_action_state)
		child.init(parent)
		_states[child.name] = child
	change_state(initial_state)
	if _active_state == null:
		_states.clear()

func has_state(state_name : StringName) -> bool:
	return state_name in _states

func set_action_state(state_name : StringName, auto_transition : bool = false, data : Dictionary = {}) -> void:
	if state_name in _states:
		_action_state = _states[state_name]
		action_state_changed.emit(_action_state.name)
		if auto_transition:
			change_to_action_state(data)

func clear_action_state() -> void:
	if _action_state != null:
		var transition : bool = _action_state == _active_state
		_action_state = null
		action_state_changed.emit(&"")
		if transition:
			change_to_action_state()

func has_action_state() -> bool:
	return _action_state != null

func get_action_state_name() -> StringName:
	if _action_state != null:
		return _action_state.name
	return &""

func change_state(state : FiniteState, data : Dictionary = {}) -> void:
	if _active_state == state: return # Already the active state.
	if _active_state != null:
		_active_state.exit()
	_active_state = state
	if _active_state != null:
		_active_state.enter(data)
		state_changed.emit(_active_state.name)
	else:
		state_changed.emit(&"")

func change_state_by_name(state_name : StringName, data : Dictionary = {}) -> void:
	for child in get_children():
		if child is FiniteState and child.name == state_name:
			change_state(child, data)
			break

func change_to_action_state(data : Dictionary = {}) -> void:
	if _action_state != null:
		change_state(_action_state, data)
	else:
		change_state(initial_state, data)

func get_current_state_name() -> StringName:
	if _active_state != null:
		return _active_state.name
	return &""

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



