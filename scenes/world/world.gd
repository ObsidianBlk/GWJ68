extends Node2D
class_name World

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const MENU_MAIN : StringName = &"MainMenu"
const MENU_PAUSE : StringName = &"PauseMenu"
const MENU_LEVELSELECT : StringName = &"LevelSelectMenu"

const MENU_LEVEL_SUCCESS : StringName = &"LevelSuccess"
const MENU_LEVEL_FAILED : StringName = &"LevelFailed"

const BACKDROP_GAME_TITLE : StringName = &"Backdrop_GameTitle"
const BACKDROP_001 : StringName = &"Backdrop_001"

#const INITIAL_LEVEL : String = "res://scenes/levels/test_level/test_level.tscn"
#const INITIAL_LEVEL : String = "res://scenes/levels/level_001/level_001.tscn"
#const INITIAL_LEVEL : String = "res://scenes/levels/level_005/level_005.tscn"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Game World")
@export var ui : UILayer = null:					set = set_ui

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _active_level_src : String = ""
var _active_level : Level = null

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _level_container: Node2D = $LevelContainer



# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_ui(u : UILayer) -> void:
	if u == ui: return
	_DisconnectUI()
	ui = u
	_ConnectUI()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	if Settings.load() != OK:
		Settings.request_reset()
		Settings.save()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _active_level != null:
			if get_tree().paused:
				get_tree().paused = false
				ui.close_all()
			else:
				get_tree().paused = true
				ui.show_ui(MENU_PAUSE)
		else:
			get_tree().quit()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _DisconnectUI() -> void:
	if ui == null: return
	if ui.requested.is_connected(_on_ui_requested):
		ui.requested.disconnect(_on_ui_requested)

func _ConnectUI() -> void:
	if ui == null: return
	if not ui.requested.is_connected(_on_ui_requested):
		ui.requested.connect(_on_ui_requested)

func _Quit() -> void:
	if Settings.is_dirty():
		Settings.save()
	get_tree().quit()

func _UnloadActiveLevel() -> void:
	if _active_level == null: return
	
	if _active_level.requested.is_connected(_on_level_requested):
		_active_level.requested.disconnect(_on_level_requested)
	
	_level_container.remove_child(_active_level)
	_active_level.queue_free()
	_active_level = null
	_active_level_src = ""

func _LoadLevel(level_src : String) -> int:
	# Load level's PackedScene
	var level_scene : Resource = load(level_src)
	if level_scene == null or not level_scene is PackedScene:
		printerr("Failed to load scene, ", level_src)
		return ERR_FILE_CANT_OPEN
	
	# Instantiate the level scene.
	var level_node : Node2D = level_scene.instantiate()
	if level_node == null or not level_node is Level:
		printerr("Failed to instantiate node or node is not Level type.")
		return ERR_CANT_CREATE
	
	# Unload any current level that may be loaded.
	_UnloadActiveLevel()
	
	# Add the new level node to the scene. We should be off to the races now!
	_active_level = level_node
	_active_level_src = level_src
	_active_level.process_mode = Node.PROCESS_MODE_PAUSABLE
	if not _active_level.requested.is_connected(_on_level_requested):
		_active_level.requested.connect(_on_level_requested)
	
	_level_container.add_child(_active_level)
	
	return OK

func _ChangeLevel(level_src : String) -> int:
	get_tree().paused = true
	_UnloadActiveLevel()
	var res : int = _LoadLevel(level_src)
	if res == OK:
		ui.close_all()
		Backdrops.Hide_Backdrops()
		get_tree().paused = false
	else:
		ui.open_notify_dialog(
			"Level Load Failure",
			"Failed to load the initial level. This is a serious issue.\nHAVE FUN!!",
			UILayer.REQUEST_QUIT_TO_MAIN
		)
	return res

# ------------------------------------------------------------------------------
# Public Static Methods
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_ui_requested(action : StringName, payload : Dictionary) -> void:
	if ui == null: return
	match action:
		UILayer.REQUEST_TOGGLE_PAUSE:
			get_tree().paused = not get_tree().paused
		UILayer.REQUEST_START_GAME:
			if _active_level != null: return # Don't start a new game if we're running one.
			ui.show_ui(MENU_LEVELSELECT)
			#_ChangeLevel(Game.INITIAL_LEVEL)
		UILayer.REQUEST_RESTART_LEVEL:
			if _active_level == null: return # Nothing to restart!
			_ChangeLevel(_active_level_src)
		UILayer.REQUEST_LOAD_LEVEL:
			if not "src" in payload: return
			if typeof(payload["src"]) == TYPE_STRING:
				if _active_level == null:
					Game.reset_run()
				_ChangeLevel(payload["src"])
		UILayer.REQUEST_QUIT_TO_MAIN:
			if _active_level != null:
				_UnloadActiveLevel()
			Backdrops.Show_Backdrop(BACKDROP_001)
			Backdrops.Show_Backdrop(BACKDROP_GAME_TITLE)
			ui.show_ui(MENU_MAIN)
		UILayer.REQUEST_QUIT_APPLICATION:
			_Quit()

func _on_level_requested(action : StringName, payload : Dictionary = {}) -> void:
	match action:
		Level.REQUEST_LEVEL_SUCCESS:
			get_tree().paused = true
			ui.show_ui(MENU_LEVEL_SUCCESS, payload)
		Level.REQUEST_LEVEL_FAILED:
			get_tree().paused = true
			ui.show_ui(MENU_LEVEL_FAILED, payload)

