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
var _next_level_src : String = ""


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _slideout: SlideoutMarginContainer = %Slideout
@onready var _lbl_saved: Label = %LBL_Saved
@onready var _lbl_required: Label = %LBL_Required
@onready var _btn_next_level: Button = %BTN_NextLevel


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# "Virtual" Private Methods
# ------------------------------------------------------------------------------
func _visibility_updating(data : Dictionary) -> void:
	if not visible:
		if "required" in data:
			_lbl_required.text = "%s"%[data["required"]]
		if "saved" in data:
			_lbl_saved.text = "%s"%[data["saved"]]
		_next_level_src = ""
		if "next_level_src" in data:
			_next_level_src = data["next_level_src"]
			_btn_next_level.visible = not _next_level_src.is_empty()
		else:
			_btn_next_level.visible = false
		_slideout.slide_in(true)
	else:
		_slideout.slide_out(true)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_btn_quit_pressed() -> void:
	request(UILayer.REQUEST_QUIT_TO_MAIN)


func _on_btn_next_level_pressed() -> void:
	if not _next_level_src.is_empty():
		request(UILayer.REQUEST_LOAD_LEVEL, {"src":_next_level_src})
