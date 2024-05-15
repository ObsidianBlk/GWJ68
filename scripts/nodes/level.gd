extends Node2D
class_name Level

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal requested(action : StringName, payload : Dictionary)
signal bot_saved(save_count : int, required_count : int)
signal bot_entered()
signal bot_removed()


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const REQUEST_LEVEL_SUCCESS : StringName = &"level_success"
const REQUEST_LEVEL_FAILED : StringName = &"level_failed"

const PAUSABLE_GROUP : StringName = &"pausable"

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

var _paused : bool = false

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
	Game.add_level_stat_entry(name, required_saved)
	bot_saved.emit(_bots_saved, required_saved)

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
		Game.stop_run()
	elif not Game.is_running():
		Game.start_run()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectBotContainer() -> void:
	if bot_container == null: return
	if not bot_container.child_entered_tree.is_connected(_on_bot_container_child_entered):
		bot_container.child_entered_tree.connect(_on_bot_container_child_entered)
	if not bot_container.child_exiting_tree.is_connected(_on_bot_container_child_exited):
		bot_container.child_exiting_tree.connect(_on_bot_container_child_exited)

func _DisconnectBotContainer() -> void:
	if bot_container == null: return
	if bot_container.child_entered_tree.is_connected(_on_bot_container_child_entered):
		bot_container.child_entered_tree.disconnect(_on_bot_container_child_entered)
	if bot_container.child_exiting_tree.is_connected(_on_bot_container_child_exited):
		bot_container.child_exiting_tree.disconnect(_on_bot_container_child_exited)

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

static func Pause_Level(pause : bool) -> void:
	if _Instance == null: return
	_Instance.pause_level(pause)

static func Is_Paused() -> bool:
	if _Instance == null: return false
	return _Instance.is_paused()

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func request(action : StringName, payload : Dictionary = {}) -> void:
	requested.emit(action, payload)

func bot_rescued() -> void:
	_bots_saved += 1
	Game.store_level_saved_count(name, _bots_saved)
	bot_saved.emit(_bots_saved, required_saved)

func build_at(pos : Vector2) -> void:
	if map == null: return
	map.set_cell(layer, map.local_to_map(pos), 0, atlas_id)

func pause_level(pause : bool) -> void:
	var pnodes : Array[Node] = get_tree().get_nodes_in_group(PAUSABLE_GROUP)
	for node : Node in pnodes:
		if pause:
			node.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			node.process_mode = Node.PROCESS_MODE_INHERIT
		_paused = pause

func is_paused() -> bool:
	return _paused

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_bot_container_child_entered(node : Node) -> void:
	if node is LilBot:
		_bots_entered += 1
		Game.store_level_spanwed_count(name, _bots_entered)
		bot_entered.emit()

func _on_bot_container_child_exited(node : Node) -> void:
	if node is LilBot:
		bot_removed.emit()

