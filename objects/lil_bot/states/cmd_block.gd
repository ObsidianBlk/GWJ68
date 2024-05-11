extends LilBotState


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const INITIAL_LOOK_DELAY : float = 4.0
const MIN_LOOK_DELAY : float = 1.0
const MAX_LOOK_DELAY : float = 4.0


const ANIM_BLOCK_START : StringName = &"block_start"
const ANIM_BLOCK_END : StringName = &"block_end"
const ANIM_LOOK_LEFT : StringName = &"look_left"
const ANIM_LOOK_RIGHT : StringName = &"look_right"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("CMD Block")
@export var idle_state : FiniteState = null
@export_flags_2d_physics var collision : int = 0


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _original_collision : int = 0
var _look_delay : float = INITIAL_LOOK_DELAY

# ------------------------------------------------------------------------------
# Public "Virtual" Methods
# ------------------------------------------------------------------------------
func init(parent : Actor) -> int:
	var res : int = super.init(parent)
	if res == OK:
		_original_collision = parent.collision_layer
	return res

func enter(data : Dictionary = {}) -> void:
	_parent.collision_layer = _original_collision | collision
	_parent.velocity = Vector2.ZERO
	play_animation(&"block_start")
	super.enter(data)

func exit() -> void:
	_parent.collision_layer = _original_collision
	if _parent.is_on_floor():
		play_animation(&"block_end")
		on_anim_finished(func(): state_exited.emit())
	else:
		super.exit()

func process_frame(delta : float) -> void:
	if _look_delay <= 0.0: return
	_look_delay -= delta
	
	if _look_delay > 0.0: return
	var anim_name : StringName = ANIM_LOOK_LEFT if randf() < 0.5 else ANIM_LOOK_RIGHT
	play_animation(anim_name)
	_look_delay = randf_range(MIN_LOOK_DELAY, MAX_LOOK_DELAY)

func process_physics(delta : float) -> void:
	if _parent == null: return
	if not _parent.is_on_floor():
		transition_state(idle_state)
	else:
		# This updates a CharacterBody2D's is_on_floor() method
		_parent.move_and_slide()
