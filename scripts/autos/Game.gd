extends Node

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const LEVELS : Array[String] = [
	"res://scenes/levels/level_001/level_001.tscn",
	"res://scenes/levels/level_002/level_002.tscn",
	"res://scenes/levels/level_003/level_003.tscn",
	"res://scenes/levels/level_004/level_004.tscn",
	"res://scenes/levels/level_005/level_005.tscn",
]

const INITIAL_LEVEL : String = LEVELS[0]

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _hardcore_mode : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func set_hardcore_mode(enable : bool) -> void:
	_hardcore_mode = enable

func is_hardcore_mode() -> bool:
	return _hardcore_mode

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



