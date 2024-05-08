extends BasicTrigger2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ACTION_INTERACT : StringName = &"cmd_interact"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _bots : Dictionary = {}

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
func _AnyBotInteracting() -> bool:
	for interacting : bool in _bots.values():
		if interacting:
			return true
	return false

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_trigger_area_body_entered(body : Node2D) -> void:
	if not body is LilBot: return
	if not body.action_state_changed.is_connected(_on_lilbot_action_state_changed.bind(body.name)):
		body.action_state_changed.connect(_on_lilbot_action_state_changed.bind(body.name))
	if not body.name in _bots:
		_bots[body.name] = body.get_current_action() == ACTION_INTERACT
	trigger(_AnyBotInteracting())

func _on_trigger_area_body_exited(body : Node2D) -> void:
	if not body is LilBot: return
	if body.action_state_changed.is_connected(_on_lilbot_action_state_changed.bind(body.name)):
		body.action_state_changed.disconnect(_on_lilbot_action_state_changed.bind(body.name))
	if body.name in _bots:
		_bots.erase(body.name)
	trigger(_AnyBotInteracting())

func _on_lilbot_action_state_changed(state_name : StringName, bot_name : StringName) -> void:
	if bot_name in _bots:
		_bots[bot_name] = state_name == ACTION_INTERACT
		trigger(_AnyBotInteracting())

