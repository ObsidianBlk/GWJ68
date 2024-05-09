extends LilBotState


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("CMD Block")
@export_flags_2d_physics var collision : int = 0


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _original_collision : int = 0

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
	play_animation(&"block_start")
	super.enter(data)

func exit() -> void:
	_parent.collision_layer = _original_collision
	play_animation(&"block_end")
	on_anim_finished(func(): state_exited.emit())

