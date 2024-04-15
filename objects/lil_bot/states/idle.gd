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
var _last_direction : float = 0.0

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary = {}) -> void:
	play_animation(ANIMATION_IDLE)

func process_frame(delta : float) -> void:
	if _parent == null: return
	# Need to build this out, but, at this point, I need to make a choice...
	if _parent.is_on_floor():
		transition_state(move_state)
	else:
		transition_state(air_state)

