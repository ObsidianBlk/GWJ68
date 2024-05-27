extends RelayTrigger2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const TRANSITION_DURATION : float = 1.5
const POSITION_Y_UP : float = -16.0
const POSITION_Y_DOWN : float = 16.0

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _tween : Tween = null
var _instant : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _door: StaticBody2D = %Door
@onready var _audio: AudioStreamPlayer2D = %Audio


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_instant = true
	super._ready()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _TransitionDoor(to : float) -> void:
	if _door == null: return
	if _tween != null:
		_tween.kill()
		_tween = null
	
	var total_distance : float = POSITION_Y_DOWN - POSITION_Y_UP
	var ddist = abs(_door.position.y - to)
	var dur : float = (ddist / total_distance) * TRANSITION_DURATION
	
	_audio.play()
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUINT)
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(_door, "position:y", to, dur)

func _TransitionInstant(to : float) -> void:
	if _door == null: return
	_door.position.y = to

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func trigger(on : bool) -> void:
	super.trigger(on)
	if _instant:
		_instant = false
		_TransitionInstant(POSITION_Y_UP if is_active() else POSITION_Y_DOWN)
	else:
		_TransitionDoor(POSITION_Y_UP if is_active() else POSITION_Y_DOWN)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



