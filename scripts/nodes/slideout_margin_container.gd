extends MarginContainer
class_name SlideoutMarginContainer


# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal slide_started()
signal slide_finished()
signal slide_interrupted()

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
enum SLIDE_EDGE {Right, Top, Left, Bottom}

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("SlideoutMarginContainer")
@export var slide_edge : SLIDE_EDGE = SLIDE_EDGE.Top
@export var slide_length : int = 0
@export var slide_duration : float = 0.5
@export var inverted : bool = false
@export var start_hidden : bool = false
@export var slide_on_start : bool = false
@export var slide_in_on_mouse : bool = false


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _constant_name : StringName = ""
var _hide_direction : int = 0
var _initial_edge_margin : int = 0
var _slide_tween : Tween = null

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)
	if slide_in_on_mouse:
		for child in get_children():
			if child is Control:
				child.mouse_entered.connect(_on_mouse_entered)
				child.mouse_exited.connect(_on_mouse_exited)
	
	match slide_edge:
		SLIDE_EDGE.Right:
			_constant_name = &"margin_right"
			_hide_direction = 1
		SLIDE_EDGE.Top:
			_hide_direction = 1
			_constant_name = &"margin_top"
		SLIDE_EDGE.Left:
			_hide_direction = -1
			_constant_name = &"margin_left"
		SLIDE_EDGE.Bottom:
			_hide_direction = -1
			_constant_name = &"margin_bottom"
	
	_initial_edge_margin = get_theme_constant(_constant_name)
	
	if start_hidden:
		add_theme_constant_override(_constant_name, _initial_edge_margin + (slide_length * _hide_direction))
	
	if slide_on_start:
		_Slide(not start_hidden)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateMargin(value : int) -> void:
	add_theme_constant_override(_constant_name, value)

func _Slide(hide : bool = false) -> void:
	if _slide_tween != null:
		_slide_tween.stop()
		_slide_tween = null
		slide_interrupted.emit()
	
	var dir : int = 0
	if inverted:
		dir = 0 if hide else -_hide_direction
	else:
		dir = _hide_direction if hide else 0

	var init : int = get_theme_constant(_constant_name)
	var target : int = _initial_edge_margin + (slide_length * dir)
	
	var dur : float = (float(abs(target - init)) / slide_length) * slide_duration
	if dur <= 0.001: return
	slide_started.emit()
	_slide_tween = create_tween()
	_slide_tween.tween_method(_UpdateMargin, init, target, dur)
	
	await _slide_tween.finished
	slide_finished.emit()
	_slide_tween = null

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func slide_out() -> void:
	_Slide(true)

func slide_in() -> void:
	_Slide(false)

func is_sliding() -> bool:
	return _slide_tween != null

func is_slid_in() -> bool:
	return get_theme_constant(_constant_name) == _initial_edge_margin

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_mouse_entered() -> void:
	if slide_in_on_mouse:
		slide_in()

func _on_mouse_exited() -> void:
	if slide_in_on_mouse:
		slide_out()
