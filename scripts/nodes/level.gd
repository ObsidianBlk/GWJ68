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
@export_file var next_level_src : String = ""
@export var required_saved : int = 1
@export var bot_container : Node2D = null:				set = set_bot_container
@export_subgroup("Build")
@export var map : TileMap = null
@export var layer : int = 0
@export var atlas_id : Vector2i = Vector2i.ZERO

# ------------------------------------------------------------------------------
# Static Variables
# ------------------------------------------------------------------------------
static var _Instance : Level = null

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

func _enter_tree() -> void:
	if _Instance == null:
		_Instance = self

func _exit_tree() -> void:
	if _Instance == self:
		_Instance = null

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
# Public Static Methods
# ------------------------------------------------------------------------------
static func Build_At(pos : Vector2) -> void:
	if _Instance == null: return
	_Instance.build_at(pos)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func request(action : StringName, payload : Dictionary = {}) -> void:
	requested.emit(action, payload)

func bot_rescued() -> void:
	_bots_saved += 1

func build_at(pos : Vector2) -> void:
	if map == null: return
	map.set_cell(layer, map.local_to_map(pos), 0, atlas_id)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_bot_container_child_entered(node : Node) -> void:
	if node is LilBot:
		_bots_entered += 1


