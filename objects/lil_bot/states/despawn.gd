extends LilBotState


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const ANIM_DESPAWN : StringName = &"despawn"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Despawner State")
@export var audio_library : AudioStreamLibrary = null

# ------------------------------------------------------------------------------
# Public "Virtual" Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary = {}) -> void:
	if anim_player != null:
		if not anim_player.animation_finished.is_connected(_on_animation_finished):
			anim_player.animation_finished.connect(_on_animation_finished)
		play_animation(ANIM_DESPAWN)
		if audio_library != null:
			audio_library.play_random(true)
	else:
		_parent.clear_action()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_animation_finished(anim_name : StringName) -> void:
	if anim_name == ANIM_DESPAWN:
		_parent.queue_free()
