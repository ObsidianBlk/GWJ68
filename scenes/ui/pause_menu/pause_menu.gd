extends UIControl


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Pause Menu")
@export var options_menu_name : StringName = &""

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _slideout : SlideoutMarginContainer = %Slideout
@onready var _btn_resume : Button = %BTN_Resume


# ------------------------------------------------------------------------------
# "Virtual" Private Methods
# ------------------------------------------------------------------------------
func _visibility_updating(data : Dictionary) -> void:
	if visible:
		_slideout.slide_out(true)
	else:
		_slideout.slide_in(true)
		_btn_resume.grab_focus()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_btn_resume_pressed():
	request(UILayer.REQUEST_CLOSE_ALL_UI)
	request(UILayer.REQUEST_TOGGLE_PAUSE)


func _on_btn_options_pressed():
	if options_menu_name == &"": return
	request(UILayer.REQUEST_SHOW_UI, {"ui_name":options_menu_name})


func _on_btn_restart_pressed():
	request(UILayer.REQUEST_RESTART_LEVEL)


func _on_btn_quit_pressed():
	request(UILayer.REQUEST_QUIT_TO_MAIN)
