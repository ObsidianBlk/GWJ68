extends FiniteState

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Idle State")
@export var move_state : FiniteState = null
@export var fall_state : FiniteState = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _parent : LilBot = null
var _initial_direction : float = 1.0

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func init(parent : Actor) -> void:
	if _parent != null: return
	if parent is LilBot:
		_parent = parent

func process_physics(delta : float) -> void:
	pass

func process_frame(delta : float) -> void:
	if _parent == null: return
	# Need to build this out, but, at this point, I need to make a choice...
	if _parent.is_on_floor():
		_parent.move(_initial_direction)
		transition_state(move_state)
	else:
		transition_state(fall_state)

