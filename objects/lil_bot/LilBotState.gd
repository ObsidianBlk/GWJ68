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
func init(parent : Actor) -> void:
	if _parent != null: return
	if parent is LilBot:
		_parent = parent

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func play_animation(animation : StringName) -> void:
	if anim_player == null: return
	anim_player.play(animation)
