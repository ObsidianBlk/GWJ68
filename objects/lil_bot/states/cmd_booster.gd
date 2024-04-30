extends LilBotState

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("CMD Booster")
@export var fly_speed : float = 50.0
@export var move_speed : float = 20.0
@export var duration : float = 1.0
@export var booster_particles : GPUParticles2D = null
@export var audio_library : AudioStreamLibrary = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _duration : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary) -> void:
	if not _parent.has_back_item(LilBot.BACK_ITEM_BOOSTER):
		_parent.clear_action()
	else:
		_duration = duration
		if booster_particles != null:
			booster_particles.emitting = true
		if audio_library != null:
			audio_library.play_random()

func exit() -> void:
	if booster_particles != null:
			booster_particles.emitting = false

func process_physics(_delta : float) -> void:
	pass

func process_frame(delta : float) -> void:
	if _parent == null: return
	var mult : float = LilBot.Get_Timer_Multiplier()
	_parent.velocity.y = -fly_speed
	_parent.velocity.x = move_speed if _parent.flip_h else -move_speed
	_parent.velocity *= mult
	_parent.move_and_slide()
	_duration -= delta * mult
	if _duration <= 0.0:
		_parent.enable_back_item(LilBot.BACK_ITEM_BOOSTER, false)
		_parent.clear_action()

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



