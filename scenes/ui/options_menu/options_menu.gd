extends UIControl

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _hs_vol_master: HSlider = %HS_VolMaster
@onready var _hs_vol_music: HSlider = %HS_VolMusic
@onready var _hs_vol_sfx: HSlider = %HS_VolSFX
@onready var _options_palettes: OptionButton = %Options_Palettes
@onready var _check_invert_colors = %CHECK_InvertColors

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


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
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

#func _on_settings_value_changed(section : String, key : String, value : Variant) -> void:
	#match section:
		#ScreenEffects.CONFIG_SECTION:
			#if key in _effect_checks and typeof(value) == TYPE_BOOL:
				#_effect_checks[key].button_pressed = value

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

func _on_check_invert_colors_toggled(toggled_on):
	Pal.set_palette_inverted(toggled_on)
