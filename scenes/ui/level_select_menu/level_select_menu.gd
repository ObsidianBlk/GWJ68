extends UIControl

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
var BTN_COUNT : int = 6

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _idx_offset : int = 0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _btn_level_01: Button = %BTN_Level_01
@onready var _btn_level_02: Button = %BTN_Level_02
@onready var _btn_level_03: Button = %BTN_Level_03
@onready var _btn_level_04: Button = %BTN_Level_04
@onready var _btn_level_05: Button = %BTN_Level_05
@onready var _btn_level_06: Button = %BTN_Level_06

# ------------------------------------------------------------------------------
# "Virtual" Private Methods
# ------------------------------------------------------------------------------
func _visibility_updating(data : Dictionary) -> void:
	if not visible:
		_idx_offset = 0
		_UpdateLevelLabels()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateLevelLabels() -> void:
	var btns : Array[Button] = [
		_btn_level_01,
		_btn_level_02,
		_btn_level_03,
		_btn_level_04,
		_btn_level_05,
		_btn_level_06
	]
	
	for i in range(BTN_COUNT):
		var idx : int = i + _idx_offset
		if idx >= 0 and idx < Game.LEVELS.size():
			btns[i].text = "Level\n%s"%[idx + 1]
		else:
			btns[i].text = "Level\n--"

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_btn_prev_group_pressed() -> void:
	_idx_offset = max(0, min(Game.LEVELS.size()-(BTN_COUNT+1), _idx_offset - BTN_COUNT))
	_UpdateLevelLabels()

func _on_btn_next_group_pressed() -> void:
	_idx_offset = max(0, min(Game.LEVELS.size()-(BTN_COUNT+1), _idx_offset + BTN_COUNT))
	_UpdateLevelLabels()

func _on_level_btn_pressed(btn_idx : int) -> void:
	var idx : int = _idx_offset + btn_idx
	if idx >= 0 and idx < Game.LEVELS.size():
		Game.set_hardcore_mode(false)
		request(UILayer.REQUEST_LOAD_LEVEL, {"src":Game.LEVELS[idx]})

func _on_btn_hard_core_pressed() -> void:
	Game.set_hardcore_mode(true)
	request(UILayer.REQUEST_LOAD_LEVEL, {"src":Game.INITIAL_LEVEL})

func _on_btn_back_pressed() -> void:
	request(UILayer.REQUEST_CLOSE_UI)
