extends UIControl

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const OBS_ITCH_URI : String = "https://obsidianblk.itch.io/"
const GWJ68_URI : String = "https://itch.io/jam/godot-wild-jam-68"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Main Menu")
@export var options_menu_name : StringName = &""

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _bottom_bar: SlideoutMarginContainer = %BottomBar
@onready var _lbl_version: Label = %LBL_Version


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	_lbl_version.text = "Version: " + ProjectSettings.get_setting("application/config/version", "1.0")

# ------------------------------------------------------------------------------
# "Virtual" Private Methods
# ------------------------------------------------------------------------------
func _visibility_updating(data : Dictionary) -> void:
	if visible:
		_bottom_bar.slide_out()
	else:
		_bottom_bar.slide_in()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------


func _on_btn_start_pressed() -> void:
	request(UILayer.REQUEST_START_GAME)


func _on_btn_options_pressed() -> void:
	if options_menu_name == &"": return
	request(UILayer.REQUEST_SHOW_UI, {"ui_name":options_menu_name})


func _on_btn_quit_pressed() -> void:
	request(UILayer.REQUEST_SHOW_UI, {
		"ui_name":&"DialogConfirm",
		"ui_data":{
			"yes_action": UILayer.REQUEST_QUIT_APPLICATION,
			"title": "Quit Game",
			"content": "Are you sure you want to quit the game?"
		}
	})

func _on_btn_oblogo_pressed() -> void:
	OS.shell_open(OBS_ITCH_URI)

func _on_btn_gwj_pressed() -> void:
	OS.shell_open(GWJ68_URI)
