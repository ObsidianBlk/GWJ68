@tool
extends ColorRect
class_name ColorRectPost


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("ColorRectPost")
@export var run_color : Color = Color.BLACK


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	if not Engine.is_editor_hint():
		color = run_color
