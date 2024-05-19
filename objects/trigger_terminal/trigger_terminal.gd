@tool
extends BasicTrigger2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ACTION_INTERACT : StringName = &"cmd_interact"

const ANIM_IDLE : StringName = &"idle"
const ANIM_ACTIVE : StringName = &"active"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Trigger Terminal")
@export var toggle : bool = false:				set = set_toggle

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _bots : Dictionary = {}
var _toggle_on : bool = false
var _can_toggle : bool = true

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _anim_sprite: AnimatedSprite2D = %AnimSprite
@onready var _symbol_toggle: Sprite2D = $SymbolToggle
@onready var _symbol_hold: Sprite2D = $SymbolHold


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_toggle(t : bool) -> void:
	toggle = t
	_UpdateToggleSymbol()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateToggleSymbol()
	

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateToggleSymbol() -> void:
	if _symbol_toggle == null or _symbol_hold == null: return
	_symbol_hold.visible = not toggle
	_symbol_toggle.visible = toggle

func _AnyBotInteracting() -> bool:
	for interacting : bool in _bots.values():
		if interacting:
			return true
	return false

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func trigger(on : bool) -> void:
	if Engine.is_editor_hint(): return
	super.trigger(on)
	_anim_sprite.play(ANIM_ACTIVE if on else ANIM_IDLE)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_trigger_area_body_entered(body : Node2D) -> void:
	if Engine.is_editor_hint(): return
	if not body is LilBot: return
	if not body.action_state_changed.is_connected(_on_lilbot_action_state_changed.bind(body.name)):
		body.action_state_changed.connect(_on_lilbot_action_state_changed.bind(body.name))
	if not body.name in _bots:
		_bots[body.name] = body.get_current_action() == ACTION_INTERACT
	body.set_interactable(true)
	#trigger(_AnyBotInteracting())

func _on_trigger_area_body_exited(body : Node2D) -> void:
	if Engine.is_editor_hint(): return
	if not body is LilBot: return
	if body.action_state_changed.is_connected(_on_lilbot_action_state_changed.bind(body.name)):
		body.action_state_changed.disconnect(_on_lilbot_action_state_changed.bind(body.name))
	if body.name in _bots:
		_bots.erase(body.name)
	body.set_interactable(false)
	#trigger(_AnyBotInteracting())

func _on_lilbot_action_state_changed(state_name : StringName, bot_name : StringName) -> void:
	if bot_name in _bots:
		_bots[bot_name] = state_name == ACTION_INTERACT
		if toggle:
			if _can_toggle == _AnyBotInteracting():
				if _can_toggle:
					_toggle_on = not _toggle_on
					trigger(_toggle_on)
				_can_toggle = not _can_toggle
		else:
			trigger(_AnyBotInteracting())

