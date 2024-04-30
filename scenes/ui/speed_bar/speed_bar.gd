extends MarginContainer


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _btngroup : ButtonGroup = null

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _button_container : HBoxContainer = %ButtonContainer


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_btngroup = ButtonGroup.new()
	for child : Node in _button_container.get_children():
		if child is BaseButton:
			child.button_group = _btngroup
	_btngroup.pressed.connect(_on_button_pressed)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _PauseLevel(pause : bool) -> void:
	var is_paused = Level.Is_Paused()
	if is_paused != pause:
		Level.Pause_Level(pause)
		Relay.request(&"lock_commands", {"lock":pause})

func _SetTimeMultiplier(multiplier : float) -> void:
	var payload : Dictionary = {}
	payload[LilBot.PAYLOAD_PROPERTY] = multiplier
	Relay.request(LilBot.ACTION_TIME_MULTIPLIER, payload)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_button_pressed(btn : BaseButton) -> void:
	var payload = {}
	match btn.name:
		&"BTN_Pause":
			_PauseLevel(true)
		&"BTN_Normal":
			_PauseLevel(false)
			_SetTimeMultiplier(1.0)
		&"BTN_TimeHalf":
			_PauseLevel(false)
			_SetTimeMultiplier(1.5)
		&"BTN_DoubleTime":
			_PauseLevel(false)
			_SetTimeMultiplier(2.0)

