extends UIControl

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


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------Label------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _hs_vol_master: HSlider = %HS_VolMaster
@onready var _hs_vol_music: HSlider = %HS_VolMusic
@onready var _hs_vol_sfx: HSlider = %HS_VolSFX
@onready var _options_palettes: OptionButton = %Options_Palettes
@onready var _check_invert_colors = %CHECK_InvertColors
@onready var _spin_m_sens_x : SpinBox = %SPIN_MSensX
@onready var _spin_m_sens_y : SpinBox = %SPIN_MSensY
@onready var _check_m_invert_x : CheckBox = %CHECK_MInvertX
@onready var _check_m_invert_y : CheckBox = %CHECK_MInvertY

@onready var _effect_checks : Dictionary = {
	"CRT": %CHECK_EffectCRT
}

# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	Settings.loaded.connect(_on_settings_loaded)
	Settings.reset.connect(_on_settings_reset)
	Settings.value_changed.connect(_on_settings_value_changed)
	
	GAS.volume_changed.connect(_on_volume_changed)
	_on_volume_changed(GAS.BUS_MASTER, GAS.get_volume(GAS.BUS_MASTER))
	_on_volume_changed(GAS.BUS_SFX, GAS.get_volume(GAS.BUS_SFX))
	_on_volume_changed(GAS.BUS_MUSIC, GAS.get_volume(GAS.BUS_MUSIC))
	
	var se : ScreenEffects = ScreenEffects.Get()
	if se != null:
		se.effect_changed.connect(_on_screen_effect_changed)
		for key in _effect_checks.keys():
			_on_screen_effect_changed(key, ScreenEffects.Is_Effect_Enabled(key))
	else:
		printerr("Failed to find Screen Effects")
	
	Pal.palette_changed.connect(_on_palette_changed)
	Pal.palette_inverted.connect(_on_palette_inverted)
	_UpdatePaletteList()
	_check_invert_colors.button_pressed = Pal.is_palette_inverted()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdatePaletteList() -> void:
	if _options_palettes == null: return
	for i : int in range(Pal.palette_count()):
		_options_palettes.add_item(Pal.get_palette_name(i))
		_options_palettes.set_item_metadata(i, i)
	_options_palettes.selected = Pal.get_current_palette_index()

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------16------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_settings_loaded() -> void:
	var sens = Settings.get_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_SENSITIVITY_X, DEFAULT_MOUSE_SENSITIVITY_X)
	if typeof(sens) == TYPE_FLOAT:
		_spin_m_sens_x.value = sens
	
	sens = Settings.get_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_SENSITIVITY_Y, DEFAULT_MOUSE_SENSITIVITY_Y)
	if typeof(sens) == TYPE_FLOAT:
		_spin_m_sens_y.value = sens
	
	var invert = Settings.get_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_INVERT_X, DEFAULT_INVERT_MOUSE_X)
	if typeof(invert) == TYPE_BOOL:
		_check_m_invert_x.button_pressed = invert
	
	invert = Settings.get_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_INVERT_Y, DEFAULT_INVERT_MOUSE_Y)
	if typeof(invert) == TYPE_BOOL:
		_check_m_invert_y.button_pressed = invert


func _on_settings_reset() -> void:
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_SENSITIVITY_X, DEFAULT_MOUSE_SENSITIVITY_X)
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_SENSITIVITY_Y, DEFAULT_MOUSE_SENSITIVITY_Y)
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_INVERT_X, DEFAULT_INVERT_MOUSE_X)
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_INVERT_Y, DEFAULT_INVERT_MOUSE_Y)

func _on_settings_value_changed(section : String, key : String, value : Variant) -> void:
	if section != CONFIG_SECTION: return
	match key:
		CONFIG_KEY_MOUSE_SENSITIVITY_X:
			if typeof(value) == TYPE_FLOAT:
				_spin_m_sens_x.value = value
		CONFIG_KEY_MOUSE_SENSITIVITY_Y:
			if typeof(value) == TYPE_FLOAT:
				_spin_m_sens_y.value = value
		CONFIG_KEY_MOUSE_INVERT_X:
			if typeof(value) == TYPE_BOOL:
				_check_m_invert_x.button_pressed = value
		CONFIG_KEY_MOUSE_INVERT_Y:
			if typeof(value) == TYPE_BOOL:
				_check_m_invert_y.button_pressed = value

func _on_volume_changed(bus_name : StringName, value : float) -> void:
	var slider : HSlider = _hs_vol_master
	match bus_name:
		GAS.BUS_SFX:
			slider = _hs_vol_sfx
		GAS.BUS_MUSIC:
			slider = _hs_vol_music
	value = max(0.0, min(slider.max_value, value))
	slider.value = value

func _on_screen_effect_changed(effect_name : String, enabled : bool) -> void:
	if effect_name in _effect_checks:
		_effect_checks[effect_name].button_pressed = enabled

func _on_palette_changed(palidx : int) -> void:
	_options_palettes.selected = palidx

func _on_palette_inverted(inverted : bool) -> void:
	_check_invert_colors.button_pressed = inverted

func _on_btn_apply_pressed() -> void:
	Settings.save()

func _on_btn_back_pressed() -> void:
	request(UILayer.REQUEST_CLOSE_UI)

func _on_hs_vol_master_value_changed(value: float) -> void:
	GAS.set_volume(GAS.BUS_MASTER, value)

func _on_hs_vol_music_value_changed(value: float) -> void:
	GAS.set_volume(GAS.BUS_MUSIC, value)

func _on_hs_vol_sfx_value_changed(value: float) -> void:
	GAS.set_volume(GAS.BUS_SFX, value)

func _on_check_effect_toggled(toggled_on: bool, effect_name : String) -> void:
	ScreenEffects.Enable_Effect(effect_name, toggled_on)

func _on_options_palettes_item_selected(idx : int) -> void:
	Pal.set_current_palette_index(idx)

func _on_check_invert_colors_toggled(toggled_on : bool) -> void:
	Pal.set_palette_inverted(toggled_on)

func _on_spin_m_sens_x_value_changed(value : float) -> void:
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_SENSITIVITY_X, value)

func _on_spin_m_sens_y_value_changed(value : float) -> void:
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_SENSITIVITY_Y, value)

func _on_check_m_invert_x_toggled(toggled_on : bool) -> void:
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_INVERT_X, toggled_on)

func _on_check_m_invert_y_toggled(toggled_on : bool) -> void:
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY_MOUSE_INVERT_Y, toggled_on)
