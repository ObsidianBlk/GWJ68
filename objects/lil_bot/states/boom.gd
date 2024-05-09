extends LilBotState


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const ANIM_EXPLODE : StringName = &"explode"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Boom State")
@export var audio_library : AudioStreamLibrary = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _anim_finished : bool = false
var _audio_finished : bool = false

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _DieIfFinished() -> void:
	if _anim_finished and _audio_finished and _parent != null:
		_parent.queue_free()

# ------------------------------------------------------------------------------
# Public "Virtual" Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary = {}) -> void:
	if audio_library == null:
		_audio_finished = true
	else:
		_audio_finished = false
		if not audio_library.finished.is_connected(_on_audio_finished):
			audio_library.finished.connect(_on_audio_finished)
		
	if anim_player != null:
		_anim_finished = false
		if not anim_player.animation_finished.is_connected(_on_animation_finished):
			anim_player.animation_finished.connect(_on_animation_finished)
		play_animation(ANIM_EXPLODE)
		if audio_library != null:
			audio_library.play_random(true)
	else:
		_parent.clear_action()
	super.enter(data)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_animation_finished(anim_name : StringName) -> void:
	if anim_name == ANIM_EXPLODE:
		_anim_finished = true
		_DieIfFinished()

func _on_audio_finished() -> void:
	_audio_finished = true
	_DieIfFinished()
