extends Node2D
class_name Level

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal requested(action : StringName, payload : Dictionary)


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const REQUEST_LEVEL_SUCCESS : StringName = &"level_success"
const REQUEST_LEVEL_FAILED : StringName = &"level_failed"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Level")
@export var next_level_src : String = ""
@export var required_saved : int = 1
@export var bot_container : Node2D = null:				set = set_bot_container

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _bots_entered : int = 0
var _bots_saved : int = 0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_bot_container(c : Node2D) -> void:
	_DisconnectBotContainer()
	bot_container = c
	_ConnectBotContainer()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_ConnectBotContainer()

func _process(_delta: float) -> void:
	if bot_container == null: return
	if _bots_entered > 0 and bot_container.get_children().size() <= 0:
		_RequestNextLevel.call_deferred()
		set_process(false)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectBotContainer() -> void:
	if bot_container == null: return
	if not bot_container.child_entered_tree.is_connected(_on_bot_container_child_entered):
		bot_container.child_entered_tree.connect(_on_bot_container_child_entered)

func _DisconnectBotContainer() -> void:
	if bot_container == null: return
	if bot_container.child_entered_tree.is_connected(_on_bot_container_child_entered):
		bot_container.child_entered_tree.disconnect(_on_bot_container_child_entered)

func _RequestNextLevel() -> void:
	if _bots_saved < required_saved:
		request(REQUEST_LEVEL_FAILED, {
			"saved":_bots_saved,
			"required":required_saved
		})
	else:
		request(REQUEST_LEVEL_SUCCESS, {
			"saved":_bots_saved,
			"required":required_saved,
			"next_level_src":next_level_src
		})

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func request(action : StringName, payload : Dictionary = {}) -> void:
	requested.emit(action, payload)

func bot_rescued() -> void:
	_bots_saved += 1

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_bot_container_child_entered(node : Node) -> void:
	if node is LilBot:
		_bots_entered += 1


