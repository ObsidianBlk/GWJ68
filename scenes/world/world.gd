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

const CONFIG_SECTION : String = "SCREEN_EFFECTS"
const SCREEN_EFFECT_CRT : StringName = &"crt"

const INITIAL_LEVEL : String = "res://scenes/levels/test_level/test_level.tscn"

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
@onready var _crt: ColorRect = $ScreenEffect/CRT
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
	Settings.loaded.connect(_on_settings_loaded)
	Settings.reset.connect(_on_settings_reset)
	
	if Settings.load() != OK:
		Settings.request_reset()
		Settings.save()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _DisconnectUI() -> void:
	if ui == null: return
	if ui.requested.is_connected(_on_requested):
		ui.requested.disconnect(_on_requested)

func _ConnectUI() -> void:
	if ui == null: return
	if not ui.requested.is_connected(_on_requested):
		ui.requested.connect(_on_requested)

func _Quit() -> void:
	if Settings.is_dirty():
		Settings.save()
	get_tree().quit()

func _UnloadActiveLevel() -> void:
	if _active_level == null: return
	
	if _active_level.requested.is_connected(_on_requested):
		_active_level.requested.disconnect(_on_requested)
	
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
	if not _active_level.requested.is_connected(_on_requested):
		_active_level.requested.connect(_on_requested)
	
	_level_container.add_child(_active_level)
	
	return OK

# ------------------------------------------------------------------------------
# Public Static Methods
# ------------------------------------------------------------------------------
func _on_settings_loaded() -> void:
	var crt : bool = Settings.get_value(CONFIG_SECTION, SCREEN_EFFECT_CRT, true)
	_crt.visible = crt

func _on_settings_reset() -> void:
	Settings.set_value(CONFIG_SECTION, SCREEN_EFFECT_CRT, true)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_requested(action : StringName, payload : Dictionary) -> void:
	if ui == null: return
	match action:
		UILayer.REQUEST_TOGGLE_PAUSE:
			get_tree().paused = not get_tree().paused
		UILayer.REQUEST_START_GAME:
			if _active_level != null: return # Don't start a new game if we're running one.
			get_tree().paused = true
			#await _StartTransition(TRANSITION_HIDDEN_COLOR)
			if _LoadLevel(INITIAL_LEVEL) != OK:
				ui.open_notify_dialog(
					"Level Load Failure",
					"Failed to load the initial level. This is a serious issue.\nHAVE FUN!!",
					UILayer.REQUEST_CLOSE_UI
				)
			else:
				ui.close_all()
				#PlayerData.reset()
				#await _StartTransition(TRANSITION_VISIBLE_COLOR)
				get_tree().paused = false
		UILayer.REQUEST_QUIT_APPLICATION:
			_Quit()


