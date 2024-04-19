@tool
extends Node2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
enum PICK {Part, Booster}

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Pickup")
@export var pickup_item : PICK = PICK.Part:			set = set_pickup_item

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _given : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _viz: Node2D = %Viz
@onready var _part: Sprite2D = %Part
@onready var _booster: Sprite2D = %Booster


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_pickup_item(i : PICK) -> void:
	pickup_item = i
	_UpdateVisibleSprite()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateVisibleSprite()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateVisibleSprite() -> void:
	if _viz == null: return
	for child : Node in _viz.get_children():
		if child is Node2D:
			child.visible = false
	
	match pickup_item:
		PICK.Part:
			_part.visible = true
		PICK.Booster:
			_booster.visible = true

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_part_collection_area_body_entered(body: Node2D) -> void:
	if Engine.is_editor_hint(): return
	if body is LilBot and body.can_pickup() and not _given:
		_given = true
		match pickup_item:
			PICK.Part:
				body.enable_back_item(LilBot.BACK_ITEM_PART, true)
			PICK.Booster:
				body.enable_back_item(LilBot.BACK_ITEM_BOOSTER, true)
		queue_free.call_deferred()

