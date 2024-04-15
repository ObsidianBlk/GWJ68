extends LilBotState


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const ANIMATION_JUMP : StringName = &"jump"
const ANIMATION_FALL : StringName = &"fall"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Move State")
@export var idle_state : FiniteState = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary = {}) -> void:
	if _parent == null: return
	if _parent.velocity.y > 0.0:
		play_animation(ANIMATION_JUMP)
	else:
		play_animation(ANIMATION_FALL)

func process_physics(delta : float) -> void:
	if _parent == null: return
	if _parent.is_on_floor():
		_parent.velocity = Vector2.ZERO
		transition_state(idle_state)
	else:
		_parent.velocity.x = 0.0
		_parent.velocity.y = get_gravity()
		_parent.move_and_slide()
