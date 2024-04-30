extends Actor
class_name LilBot

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal part_count_changed(part_count : int)
signal pickup_obtained(item_name : StringName)
signal pickup_lost(item_name : StringName)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ACTION_TIME_MULTIPLIER : StringName = &"botty_time_multiplier"
const PAYLOAD_PROPERTY : String = "multiplier"

const BACK_ITEM_PART : StringName = &"Part"
const BACK_ITEM_BOOSTER : StringName = &"Booster"

const MAX_PARTS : int = 12

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("LilBot")
@export var initial_direction : Actor.DIRECTION = Actor.DIRECTION.Left
@export var flip_h : bool:					set=set_flip_h,get=get_flip_h
@export var flip_v : bool:					set=set_flip_v,get=get_flip_v

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _flipped_h : bool = false
var _flipped_v : bool = false
var _back_items : Dictionary = {}

var _part_count : int = 0

var _timer_multiplier : float = 1.0 # This is to adjust the timings used by various states

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _viz: Node2D = %Viz
@onready var _selector: AnimatedSprite2D = %Selector
@onready var _hard_hat : Sprite2D = %HardHat

@onready var _part: Sprite2D = %Part
@onready var _booster: Sprite2D = %Booster


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_flip_h(f : bool) -> void:
	_flipped_h = f
	_UpdateFlip()

func get_flip_h() -> bool:
	return _flipped_h

func set_flip_v(f : bool) -> void:
	_flipped_v = f
	_UpdateFlip()

func get_flip_v() -> bool:
	return _flipped_v

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	Relay.requested.connect(_on_relay_requested)
	_back_items[BACK_ITEM_PART] = _part
	_back_items[BACK_ITEM_BOOSTER] = _booster

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateFlip() -> void:
	if _viz == null: return
	_viz.scale = Vector2(
		-1.0 if _flipped_h else 1.0,
		-1.0 if _flipped_v else 1.0
	)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func show_selector(enable : bool) -> void:
	if _selector != null:
		_selector.visible = enable

func is_selector_visible() -> bool:
	if _selector != null:
		return _selector.visible
	return false

func show_hard_hat(enable : bool) -> void:
	if _hard_hat != null:
		_hard_hat.visible = enable

func use_part() -> void:
	if _part_count > 0:
		_part_count -= 1
		part_count_changed.emit(_part_count)

func get_part_count() -> int:
	return _part_count

func enable_back_item(item_name : StringName, enable : bool) -> void:
	if item_name in _back_items:
		_back_items[item_name].visible = enable
		if enable:
			pickup_obtained.emit(item_name)
		else:
			pickup_lost.emit(item_name)
		
		if enable and item_name == BACK_ITEM_PART:
			_part_count = MAX_PARTS
			part_count_changed.emit(_part_count)

func has_back_item(item_name : StringName) -> bool:
	if item_name in _back_items:
		return _back_items[item_name].visible
	return false

func has_any_back_item() -> bool:
	for item : Node2D in _back_items.values():
		if item.visible:
			return true
	return false

func can_pickup() -> bool:
	if not _back_items.is_empty():
		return not has_any_back_item()
	return false

func set_timer_multiplier(multiplier : float) -> void:
	if multiplier > 0.0:
		_timer_multiplier = multiplier

func get_timer_multiplier() -> float:
	return _timer_multiplier

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_relay_requested(action : StringName, payload : Dictionary = {}) -> void:
	if action == ACTION_TIME_MULTIPLIER:
		if PAYLOAD_PROPERTY in payload and typeof(payload[PAYLOAD_PROPERTY]) == TYPE_FLOAT:
			set_timer_multiplier(payload[PAYLOAD_PROPERTY])


