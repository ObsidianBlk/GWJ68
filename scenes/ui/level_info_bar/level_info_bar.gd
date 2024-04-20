extends SlideoutMarginContainer

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("LevelInfoBar")

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _bots_entered : int = 0
var _bots_removed : int = 0
var _bots_saved : int = 0
var _bots_total : int = 0
var _bots_required : int = 0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _lbl_spawning_value: Label = %LBL_Spawning_Value
@onready var _lbl_lost_value: Label = %LBL_Lost_Value
@onready var _lbl_prog_value: Label = %LBL_Prog_Value


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateInformation() -> void:
	if _lbl_spawning_value == null: return
	_lbl_spawning_value.text = "%s / %s"%[_bots_entered, _bots_total]
	_lbl_prog_value.text = "%s / %s"%[_bots_saved, _bots_required]
	_lbl_lost_value.text = "%s"%[max(0, _bots_removed - _bots_saved)]

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func bots_saved(count : int, required : int) -> void:
	_bots_saved = count
	_bots_required = required
	_UpdateInformation()

func bots_spawned(count : int, total : int) -> void:
	_bots_total = total
	_bots_entered = count
	_UpdateInformation()

func bot_removed() -> void:
	_bots_removed += 1
	_UpdateInformation()


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



