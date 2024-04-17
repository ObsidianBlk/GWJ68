extends Node

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal palette_changed(pal_index : int)

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const CONFIG_SECTION : String = "SCREEN_EFFECTS"
const CONFIG_KEY : String = "palette_index"

const PALETTES : Dictionary = {
	"Warm Ochre": preload("res://assets/graphics/palettes/warm-ochre-4-1x.png"),
	"2Bit Demichrome": preload("res://assets/graphics/palettes/2bit-demichrome-4-1x.png"),
	"Fiery Plague GB": preload("res://assets/graphics/palettes/fiery-plague-gb-4-1x.png"),
	"Gold GB": preload("res://assets/graphics/palettes/gold-gb-4-1x.png"),
	"Moonlight GB": preload("res://assets/graphics/palettes/moonlight-gb-4-1x.png"),
	"Nostalgia": preload("res://assets/graphics/palettes/nostalgia-4-1x.png"),
	"Velvet Cherry GB": preload("res://assets/graphics/palettes/velvet-cherry-gb-4-1x.png")
}

const INDEX_PALETTE : Array[String] = [
	"Warm Ochre",
	"2Bit Demichrome",
	"Fiery Plague GB",
	"Gold GB",
	"Moonlight GB",
	"Nostalgia",
	"Velvet Cherry GB"
]

const DEFAULT_PALETTE : int = 0

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _current_palette : int = 0

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	Settings.loaded.connect(_on_settings_loaded)
	Settings.reset.connect(_on_settings_reset)
	Settings.value_changed.connect(_on_settings_value_changed)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func palette_count() -> int:
	return INDEX_PALETTE.size()

func get_current_palette_index() -> int:
	return _current_palette

func set_current_palette_index(idx : int) -> int:
	if idx >= 0 and idx < INDEX_PALETTE.size():
		_current_palette = idx
		Settings.set_value(CONFIG_SECTION, CONFIG_KEY, _current_palette)
		#palette_changed.emit(_current_palette)
		return OK
	return ERR_PARAMETER_RANGE_ERROR

func set_current_palette(pal_name : String) -> int:
	if pal_name in PALETTES:
		var idx : int = INDEX_PALETTE.find(pal_name)
		return set_current_palette_index(idx)
	return ERR_DOES_NOT_EXIST

func get_palette_names() -> Array[String]:
	var arr : Array[String] = []
	arr.assign(INDEX_PALETTE)
	return arr

func get_palette_name(idx : int) -> String:
	if idx >= 0 and idx < INDEX_PALETTE.size():
		return INDEX_PALETTE[idx]
	return ""

func get_palette_texture(idx : int) -> Texture:
	if idx >= 0 and idx < INDEX_PALETTE.size():
		if INDEX_PALETTE[idx] in PALETTES:
			return PALETTES[INDEX_PALETTE[idx]]
	return null

func get_palette_texture_by_name(pal_name : String) -> Texture:
	if pal_name in PALETTES:
		return PALETTES[pal_name]
	return null

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_settings_loaded() -> void:
	var idx = Settings.get_value(CONFIG_SECTION, CONFIG_KEY, DEFAULT_PALETTE)
	if idx >= 0 and idx < INDEX_PALETTE.size():
		_current_palette = idx
		palette_changed.emit(_current_palette)

func _on_settings_reset() -> void:
	_current_palette = DEFAULT_PALETTE
	Settings.set_value(CONFIG_SECTION, CONFIG_KEY, DEFAULT_PALETTE)
	palette_changed.emit(_current_palette)

func _on_settings_value_changed(section : String, key : String, value : Variant) -> void:
	if section == CONFIG_SECTION and key == CONFIG_KEY and typeof(value) == TYPE_INT:
		if value >= 0 and value < INDEX_PALETTE.size():
			_current_palette = value
			palette_changed.emit(_current_palette)


