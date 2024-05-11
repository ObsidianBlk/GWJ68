extends LilBotState


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const ANIM_INTERACT_START : StringName = &"interact_start"
const ANIM_INTERACT_END : StringName = &"interact_end"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("CMD Interact")
@export var idle_state : LilBotState = null


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary = {}) -> void:
	play_animation(ANIM_INTERACT_START)
	_parent.velocity = Vector2.ZERO
	super.enter(data)

func exit() -> void:
	if _parent.is_on_floor():
		play_animation(ANIM_INTERACT_END)
		on_anim_finished(func(): state_exited.emit())
	else:
		super.exit()

func process_physics(delta : float) -> void:
	if _parent == null: return
	if not _parent.is_on_floor():
		transition_state(idle_state)
	else:
		# This updates a CharacterBody2D's is_on_floor() method
		_parent.move_and_slide()
