extends Node

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal run_time_updated(time : float)
signal bots_saved(saved : int, required : int)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const LEVELS : Array[String] = [
	"res://scenes/levels/level_001/level_001.tscn",
	"res://scenes/levels/level_002/level_002.tscn",
	"res://scenes/levels/level_003/level_003.tscn",
	"res://scenes/levels/level_004/level_004.tscn",
	"res://scenes/levels/level_005/level_005.tscn",
	"res://scenes/levels/level_006/level_006.tscn",
	"res://scenes/levels/level_007/level_007.tscn",
	"res://scenes/levels/level_008/level_008.tscn",
	"res://scenes/levels/level_009/level_009.tscn",
	"res://scenes/levels/level_010/level_010.tscn",
	"res://scenes/levels/level_011/level_011.tscn",
]

const INITIAL_LEVEL : String = LEVELS[0]

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _hardcore_mode : bool = false

var _running : bool = false
var _run_time : float = 0.0
var _run_stats : Dictionary = {}

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _process(delta : float) -> void:
	if _running:
		_run_time += delta
		run_time_updated.emit(_run_time)

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

func reset_run() -> void:
	_run_stats.clear()
	_run_time = 0.0
	run_time_updated.emit(_run_time)

func start_run() -> void:
	_running = true

func stop_run() -> void:
	_running = false

func get_run_time() -> float:
	return _run_time

func is_running() -> bool:
	return _running

func add_level_stat_entry(level_name : StringName, required_bots : int) -> void:
	_run_stats[level_name] = {
		"required":required_bots,
		"saved":0,
		"spawned":0
	}

func store_level_saved_count(level_name : StringName, saved : int) -> void:
	if level_name in _run_stats:
		_run_stats[level_name].saved = saved
		bots_saved.emit(saved, _run_stats[level_name].required)

func store_level_spanwed_count(level_name : StringName, spawned : int) -> void:
	if level_name in _run_stats:
		_run_stats[level_name].spawned = spawned

func get_level_stats(level_name : StringName) -> Dictionary:
	var stats : Dictionary = {}
	if level_name in _run_stats:
		stats["required"] = _run_stats[level_name]["required"]
		stats["saved"] = _run_stats[level_name]["saved"]
		stats["spawned"] = _run_stats[level_name]["spawned"]
		stats["lost"] = _run_stats[level_name]["spawned"] - _run_stats[level_name]["saved"]
	return stats

func get_run_statistics() -> Dictionary:
	var stats : Dictionary = {
		"required":0,
		"spawned":0,
		"saved":0,
		"lost":0,
		"levels":_run_stats.size(),
		"time":_run_time,
		"hardcore":_hardcore_mode
	}
	
	for info : Dictionary in _run_stats.values():
		stats.required += info.required
		stats.spawned += info.spawned
		stats.saved += info.saved
	stats.lost = stats.spawned - stats.saved
	
	return stats

func hms_from_float(val : float) -> String:
	if val < 0.0: return ""
	var hours : int = int(val / 3600.0)
	val -= hours * 3600.0
	
	var minutes : int = int(val / 60.0)
	val -= minutes * 60.0
	
	return "%03d:%02d:%02d"%[hours, minutes, int(val)]

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



