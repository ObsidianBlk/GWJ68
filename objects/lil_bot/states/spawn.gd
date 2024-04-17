extends LilBotState


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const ANIM_SPAWN : StringName = &"spawn"

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _original_mask : int = 0

# ------------------------------------------------------------------------------
# Public "Virtual" Methods
# ------------------------------------------------------------------------------
func init(parent : Actor) -> int:
	var res : int = super.init(parent)
	if res == OK:
		_original_mask = parent.collision_mask
	return res

func enter(data : Dictionary = {}) -> void:
	_parent.collision_mask = 0
	if anim_player != null:
		if not anim_player.animation_finished.is_connected(_on_animation_finished):
			anim_player.animation_finished.connect(_on_animation_finished)
		play_animation(ANIM_SPAWN)
	else:
		_parent.clear_action()

func exit() -> void:
	_parent.collision_mask = _original_mask
	if anim_player != null:
		if anim_player.animation_finished.is_connected(_on_animation_finished):
			anim_player.animation_finished.disconnect(_on_animation_finished)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_animation_finished(anim_name : StringName) -> void:
	if anim_name == ANIM_SPAWN:
		_parent.clear_action()
