extends LilBotState

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const ANIMATION_IDLE : StringName = &"idle"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Idle State")
@export var move_state : FiniteState = null
@export var air_state : FiniteState = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _has_action : bool = false
var _last_direction : float = 0.0

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func init(parent : Actor) -> int:
	var res : int = super.init(parent)
	if res == OK:
		var fsm : Node = get_parent()
		if fsm is FiniteStateMachine:
			fsm.action_state_changed.connect(_on_fsm_action_state_changed)
			_has_action = fsm.has_action_state()
	return res

func enter(data : Dictionary = {}) -> void:
	play_animation(ANIMATION_IDLE)

func process_frame(delta : float) -> void:
	if _parent == null: return
	# Need to build this out, but, at this point, I need to make a choice...
	if _parent.is_on_floor():
		if _has_action:
			transition_to_action()
		else:
			transition_state(move_state)
	else:
		transition_state(air_state)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_fsm_action_state_changed(state_name : StringName) -> void:
	_has_action = not state_name.is_empty()
