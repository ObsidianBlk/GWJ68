extends Camera2D
class_name PlayerCamera2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const CONFIG_SECTION : String = "GAMEPLAY"
const CONFIG_KEY_MOUSE_SENSITIVITY_X : String = "mouse_sens_x"
const CONFIG_KEY_MOUSE_SENSITIVITY_Y : String = "mouse_sens_y"
const CONFIG_KEY_MOUSE_INVERT_X : String = "mouse_invert_x"
const CONFIG_KEY_MOUSE_INVERT_Y : String = "mouse_invert_y"

const DEFAULT_MOUSE_SENSITIVITY_X : float = 0.2
const DEFAULT_MOUSE_SENSITIVITY_Y : float = 0.2
const DEFAULT_INVERT_MOUSE_X : bool = false
const DEFAULT_INVERT_MOUSE_Y : bool = false

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("PlayerCamera2D")
@export var edge_left_px : int = -1000
@export var edge_right_px : int = 1000
@export var edge_top_px : int = -1000
@export var edge_bottom_px : int = 1000

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _drag_active : bool = false
var _sensitivity : Vector2 = Vector2(
	DEFAULT_MOUSE_SENSITIVITY_X,
	DEFAULT_MOUSE_SENSITIVITY_Y
)
var _invert_x : bool = DEFAULT_INVERT_MOUSE_X
var _invert_y : bool = DEFAULT_INVERT_MOUSE_Y

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	Settings.value_changed.connect(_on_settings_value_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _drag_active:
		position += event.relative * _sensitivity * Vector2(
			1 if _invert_x else -1,
			1 if _invert_y else -1
		)
		position.x = clampf(position.x, edge_left_px, edge_right_px)
		position.y = clampf(position.y, edge_top_px, edge_bottom_px)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_drag_active = event.pressed

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# --------------------0.2----------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_settings_value_changed(section : String, key : String, value : Variant) -> void:
	if section != CONFIG_SECTION: return
	match key:
		CONFIG_KEY_MOUSE_SENSITIVITY_X:
			if typeof(value) == TYPE_FLOAT:
				_sensitivity.x = value
		CONFIG_KEY_MOUSE_SENSITIVITY_Y:
			if typeof(value) == TYPE_FLOAT:
				_sensitivity.y = value
		CONFIG_KEY_MOUSE_INVERT_X:
			if typeof(value) == TYPE_BOOL:
				_invert_x = value
		CONFIG_KEY_MOUSE_INVERT_Y:
			if typeof(value) == TYPE_BOOL:
				_invert_y = value


