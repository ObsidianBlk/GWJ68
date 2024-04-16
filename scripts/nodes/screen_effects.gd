extends CanvasLayer
class_name ScreenEffects

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal effect_changed(effect_name : String, enabled : bool)

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const CONFIG_SECTION : String = "SCREEN_EFFECTS"
const CONFIG_KEY_PREFIX : String = "effect_"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("ScreenEffects")
@export var effect_controls : Array[Control] = []


# ------------------------------------------------------------------------------
# Static Variables
# ------------------------------------------------------------------------------
static var _Instance : ScreenEffects = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _effect_keys : Dictionary = {}

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	for effect : Control in effect_controls:
		_effect_keys[effect.name] = effect
	Settings.loaded.connect(_on_settings_loaded)
	Settings.reset.connect(_on_settings_reset)
	Settings.value_changed.connect(_on_settings_value_changed)

func _enter_tree() -> void:
	if _Instance == null:
		_Instance = self

func _exit_tree() -> void:
	if _Instance == self:
		_Instance = null

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Static Public Methods
# ------------------------------------------------------------------------------
static func Get() -> ScreenEffects:
	return _Instance

static func Has_Effect(effect_name : String) -> bool:
	if _Instance == null: return false
	return _Instance.has_effect(effect_name)

static func Toggle_Effect(effect_name : String) -> void:
	if _Instance != null:
		_Instance.toggle_effect(effect_name)

static func Enable_Effect(effect_name : String, enable : bool) -> void:
	if _Instance != null:
		_Instance.enable_effect(effect_name, enable)

static func Is_Effect_Enabled(effect_name : String) -> bool:
	if _Instance == null: return false
	return _Instance.is_effect_enabled(effect_name)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func has_effect(effect_name : String) -> bool:
	return effect_name in _effect_keys

func toggle_effect(effect_name : String) -> void:
	if effect_name in _effect_keys:
		Settings.set_value(CONFIG_SECTION, effect_name, not _effect_keys[effect_name].visible)

func enable_effect(effect_name : String, enable : bool) -> void:
	if effect_name in _effect_keys:
		Settings.set_value(CONFIG_SECTION, effect_name, enable)

func is_effect_enabled(effect_name : String) -> bool:
	if effect_name in _effect_keys:
		return _effect_keys[effect_name].visible
	return false

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_settings_loaded() -> void:
	for key : String in _effect_keys.keys():
		_effect_keys[key].visible = Settings.get_value(CONFIG_SECTION, key, true)
		effect_changed.emit(key, _effect_keys[key].visible)

func _on_settings_reset() -> void:
	for key : String in _effect_keys.keys():
		Settings.set_value(CONFIG_SECTION, key, true)
		_effect_keys[key].visible = true
		effect_changed.emit(key, true)

func _on_settings_value_changed(section : String, key : String, value : Variant) -> void:
	if section == CONFIG_SECTION and typeof(value) == TYPE_BOOL:
		if key in _effect_keys:
			_effect_keys[key] . visible = value
			effect_changed.emit(key, value)

