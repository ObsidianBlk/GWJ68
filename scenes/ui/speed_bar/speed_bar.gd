extends MarginContainer


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const BTN_NAME_PAUSE : StringName = &"BTN_Pause"
const BTN_NAME_NORMAL : StringName = &"BTN_Normal"
const BTN_NAME_TIMEHALF : StringName = &"BTN_TimeHalf"
const BTN_NAME_DOUBLETIME : StringName = &"BTN_DoubleTime"

const FLOAT_THRESHOLD : float = 0.1

const MULTIPLIER_NORMAL : float = 1.0
const MULTIPLIER_TIMEHALF : float = 1.5
const MULTIPLIER_DOUBLETIME : float = 2.0

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
			match child.name:
				BTN_NAME_PAUSE:
					child.button_pressed = abs(LilBot.Get_Timer_Multiplier()) < FLOAT_THRESHOLD
				BTN_NAME_NORMAL:
					child.button_pressed = abs(LilBot.Get_Timer_Multiplier() - MULTIPLIER_NORMAL) < FLOAT_THRESHOLD
				BTN_NAME_TIMEHALF:
					child.button_pressed = abs(LilBot.Get_Timer_Multiplier() - MULTIPLIER_TIMEHALF) < FLOAT_THRESHOLD
				BTN_NAME_DOUBLETIME:
					child.button_pressed = abs(LilBot.Get_Timer_Multiplier() - MULTIPLIER_DOUBLETIME) < FLOAT_THRESHOLD
	_btngroup.pressed.connect(_on_button_pressed)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _PauseLevel(pause : bool) -> void:
	var is_paused = Level.Is_Paused()
	if is_paused != pause:
		Level.Pause_Level(pause)
		Relay.request(&"lock_commands", {"lock":pause})

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_button_pressed(btn : BaseButton) -> void:
	var payload = {}
	match btn.name:
		BTN_NAME_PAUSE:
			_PauseLevel(true)
		BTN_NAME_NORMAL:
			_PauseLevel(false)
			LilBot.Set_Timer_Multiplier(MULTIPLIER_NORMAL)
		BTN_NAME_TIMEHALF:
			_PauseLevel(false)
			LilBot.Set_Timer_Multiplier(MULTIPLIER_TIMEHALF)
		BTN_NAME_DOUBLETIME:
			_PauseLevel(false)
			LilBot.Set_Timer_Multiplier(MULTIPLIER_DOUBLETIME)

