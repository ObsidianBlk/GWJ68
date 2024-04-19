extends Actor
class_name LilBot

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const BACK_ITEM_PART : StringName = &"Part"
const BACK_ITEM_BOOSTER : StringName = &"Booster"


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

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _viz: Node2D = %Viz
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
func enable_back_item(item_name : StringName, enable : bool) -> void:
	if item_name in _back_items:
		_back_items[item_name].visible = enable

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

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



