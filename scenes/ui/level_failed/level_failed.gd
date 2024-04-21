extends UIControl


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _slideout: SlideoutMarginContainer = %Slideout
@onready var _btn_restart: Button = %BTN_Restart
@onready var _btn_quit: Button = %BTN_Quit
@onready var _audio: AudioStreamPlayer = %AudioStreamPlayer


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# "Virtual" Private Methods
# ------------------------------------------------------------------------------
func _visibility_updating(data : Dictionary) -> void:
	if not visible:
		if Game.is_hardcore_mode():
			_btn_restart.visible = false
			_btn_quit.grab_focus.call_deferred()
		else:
			_btn_restart.visible = true
			_btn_restart.grab_focus.call_deferred()
		_slideout.slide_in(true)
	else:
		_slideout.slide_out(true)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_slideout_slide_finished() -> void:
	if visible:
		_audio.play()

func _on_btn_restart_pressed() -> void:
	request(UILayer.REQUEST_RESTART_LEVEL)

func _on_btn_quit_pressed() -> void:
	request(UILayer.REQUEST_QUIT_TO_MAIN)



