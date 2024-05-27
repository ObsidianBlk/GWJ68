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
var _success : bool = false


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _slideout: SlideoutMarginContainer = %Slideout
@onready var _audio: AudioStreamPlayer = %AudioStreamPlayer

@onready var _sub_view_success: SubViewportContainer = %SubView_Success
@onready var _lbl_failed: Label = %LBL_Failed

@onready var _btn_next_level: Button = %BTN_NextLevel
@onready var _btn_retry: Button = %BTN_Retry

@onready var _level_stats: VBoxContainer = %LevelStats
@onready var _run_stats: VBoxContainer = %RunStats


@onready var _lbl_lvl_spawned_value: Label = %LBL_LVL_Spawned_Value
@onready var _lbl_lvl_required_value: Label = %LBL_LVL_Required_Value
@onready var _lbl_lvl_saved_value: Label = %LBL_LVL_Saved_Value
@onready var _lbl_lvl_lost_value: Label = %LBL_LVL_Lost_Value

@onready var _lbl_run_spawned_value: Label = %LBL_RUN_Spawned_Value
@onready var _lbl_run_required_value: Label = %LBL_RUN_Required_Value
@onready var _lbl_run_saved_value: Label = %LBL_RUN_Saved_Value
@onready var _lbl_run_lost_value: Label = %LBL_RUN_Lost_Value

@onready var _lbl_hardcore: Label = %LBL_Hardcore
@onready var _lbl_run_time: Label = %LBL_Run_Time


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
		_level_stats.visible = true
		_run_stats.visible = false
		
		_success = false
		if "success" in data and typeof(data["success"]) == TYPE_BOOL:
			_success = data["success"]
		
		_sub_view_success.visible = _success
		_lbl_failed.visible = not _success
		_btn_retry.visible = not Game.is_hardcore_mode()
		
		var stats : Dictionary = {}
		if "level_name" in data:
			stats = Game.get_level_stats(data["level_name"])
		
		if not stats.is_empty():
			_lbl_lvl_spawned_value.text = "%d"%[stats["required"]]
			_lbl_lvl_required_value.text = "%d"%[stats["required"]]
			_lbl_lvl_saved_value.text = "%d"%[stats["saved"]]
			_lbl_lvl_lost_value.text = "%d"%[stats["lost"]]
		else:
			_lbl_lvl_spawned_value.text = "?"
			_lbl_lvl_required_value.text = "?"
			_lbl_lvl_saved_value.text = "?"
			_lbl_lvl_lost_value.text = "?"
		
		stats = Game.get_run_statistics()
		_lbl_hardcore.visible = Game.is_hardcore_mode()
		_lbl_run_spawned_value.text = "%d"%[stats["required"]]
		_lbl_run_required_value.text = "%d"%[stats["required"]]
		_lbl_run_saved_value.text = "%d"%[stats["saved"]]
		_lbl_run_lost_value.text = "%d"%[stats["lost"]]
		_lbl_run_time.text = Game.hms_from_float(stats["time"])
		
		_next_level_src = ""
		if _success and "next_level_src" in data:
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
func _on_btn_retry_pressed() -> void:
	request(UILayer.REQUEST_RESTART_LEVEL)

func _on_btn_quit_pressed() -> void:
	request(UILayer.REQUEST_QUIT_TO_MAIN)


func _on_btn_next_level_pressed() -> void:
	if not _next_level_src.is_empty():
		request(UILayer.REQUEST_LOAD_LEVEL, {"src":_next_level_src})

func _on_btn_to_run_stats_pressed() -> void:
	_level_stats.visible = false
	_run_stats.visible = true

func _on_btn_to_level_stats_pressed() -> void:
	_level_stats.visible = true
	_run_stats.visible = false

func _on_slideout_slide_finished() -> void:
	if visible and not _success:
		_audio.play()
