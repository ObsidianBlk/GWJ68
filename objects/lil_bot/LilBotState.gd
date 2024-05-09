extends FiniteState
class_name LilBotState


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("LilBotState")
@export var anim_player : AnimationPlayer = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _parent : LilBot = null

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func init(parent : Actor) -> int:
	if _parent != null: return ERR_ALREADY_IN_USE
	if parent is LilBot:
		_parent = parent
		return OK
	return ERR_INVALID_PARAMETER

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func play_animation(animation : StringName) -> void:
	if anim_player == null: return
	anim_player.play(animation)

func is_animation_playing(anim_name : StringName = &"") -> bool:
	if anim_player == null: return false
	if anim_name.is_empty():
		return anim_player.is_playing()
	if anim_player.current_animation == anim_name:
		return anim_player.is_playing()
	return false

func on_anim_finished(callback : Callable) -> void:
	if anim_player == null: return
	if anim_player.is_playing():
		await anim_player.animation_finished
	callback.call()
