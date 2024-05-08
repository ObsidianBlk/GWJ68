extends BasicTrigger2D
class_name OrTrigger2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Or Trigger 2D")
@export var connections : Array[BasicTrigger2D] = []:		set = set_connections

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _connection_states : Dictionary = {}

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_connections(c : Array[BasicTrigger2D]) -> void:
	_DisconnectConnections()
	connections = c
	_ConnectConnections()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_ConnectConnections()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectConnections() -> void:
	if connections.size() <= 0: return
	for conn : BasicTrigger2D in connections:
		if not conn.state_changed.is_connected(_on_connection_state_changed.bind(conn.name)):
			conn.state_change.connect(_on_connection_state_changed.bind(conn.name))
			_connection_states[conn.name] = conn.is_active()
	trigger(_AnyConnectionActive())

func _DisconnectConnections() -> void:
	_connection_states.clear()
	if connections.size() <= 0: return
	for conn : BasicTrigger2D in connections:
		if conn.state_changed.is_connected(_on_connection_state_changed.bind(conn.name)):
			conn.state_change.disconnect(_on_connection_state_changed.bind(conn.name))

func _AnyConnectionActive() -> bool:
	for val : bool in _connection_states.values():
		if val:
			return true
	return false

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_connection_state_changed(on : bool, connection_name : StringName) -> void:
	_connection_states[connection_name] = on
	if not on:
		var on_state : bool = _AnyConnectionActive()
		if on_state != _state:
			trigger(on_state)
	elif _state != true:
		trigger(true)


