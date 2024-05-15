extends Node2D

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const LETTER_TRANSITION_DURATION : float = 2.0
const MIN_LETTER_Y : float = -8.0
const MAX_LETTER_Y : float = 8.0
const DIST_LETTER_Y : float = MAX_LETTER_Y - MIN_LETTER_Y

const TWEEN_DELAY : float = 0.2

const FLOAT_THRESHOLD : float = 0.001

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _bounce_letters : bool = true
var _bounce_index : int = 0
var _bounce_delay : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _letters : Array[Sprite2D] = [
	%Letter_01,
	%Letter_02,
	%Letter_03,
	%Letter_04,
	%Letter_05,
	%Letter_06,
	%Letter_07
]


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _process(delta : float) -> void:
	if not _bounce_letters or _bounce_index >= _letters.size(): return
	if _bounce_delay > 0.0:
		_bounce_delay -= delta
	if _bounce_delay <= 0.0:
		_bounce_delay += TWEEN_DELAY
		_TweenLetter(_bounce_index)
		_bounce_index += 1

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _TweenLetter(letter_id : int, to_origin : bool = false) -> void:
	if letter_id < 0 or letter_id >= _letters.size(): return
	
	var target_y : float = 0.0
	if not to_origin:
		var upwards : bool = _letters[letter_id].position.y >= 0.0
		target_y = MIN_LETTER_Y if upwards else MAX_LETTER_Y
	var dt : float = abs(target_y - _letters[letter_id].position.y) / DIST_LETTER_Y
	var dur : float = LETTER_TRANSITION_DURATION * dt
	
	var tween : Tween = create_tween()
	tween.tween_property(_letters[letter_id], "position:y", target_y, dur)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_tween_finished.bind(letter_id), CONNECT_ONE_SHOT)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_tween_finished(letter_id : int) -> void:
	if _bounce_letters:
		_TweenLetter(letter_id)

