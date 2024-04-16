extends CanvasLayer
class_name Backdrops


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Backdrops")
@export var always_on : Array[StringName] = []

# ------------------------------------------------------------------------------
# Static Variables
# ------------------------------------------------------------------------------
static var _Instance : Backdrops = null

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _enter_tree() -> void:
	if _Instance == null:
		_Instance = self

func _exit_tree() -> void:
	if _Instance == self:
		_Instance = null

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _IsAlwaysOn(bd_name : StringName) -> bool:
	return always_on.find(bd_name) >= 0

# ------------------------------------------------------------------------------
# Public Static Methods
# ------------------------------------------------------------------------------
static func Show_Backdrop(bd_name : StringName, only_selected : bool = false) -> void:
	if _Instance != null:
		_Instance.show_backdrop(bd_name, only_selected)

static func Hide_Backdrop(bd_name : StringName) -> void:
	if _Instance != null:
		_Instance.hide_backdrop(bd_name)

static func Hide_Backdrops() -> void:
	if _Instance != null:
		_Instance.hide_backdrops()

static func Is_Showing(bd_name : StringName) -> bool:
	if _Instance != null:
		return _Instance.is_showing(bd_name)
	return false

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func is_showing(bd_name : StringName) -> bool:
	for child : Control in get_children():
		if child.name == bd_name:
			return child.visible
	return false

func show_backdrop(bd_name : StringName, only_selected : bool = false) -> void:
	for child in get_children():
		if only_selected:
			child.visible = child.name == bd_name or _IsAlwaysOn(child.name)
		else:
			if child.name == bd_name:
				child.visible = true
				break

func hide_backdrop(bd_name : StringName) -> void:
	for child in get_children():
		if child.name == bd_name and not _IsAlwaysOn(child.name):
			child.visible = false
			break

func hide_backdrops() -> void:
	for child in get_children():
		if not _IsAlwaysOn(child.name):
			child.visible = false

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
