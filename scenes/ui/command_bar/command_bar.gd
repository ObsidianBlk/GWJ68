extends SlideoutMarginContainer

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const COMMAND_DIG : StringName = &"cmd_dig"
const COMMAND_MINE : StringName = &"cmd_mine"
const COMMAND_TUNNEL : StringName = &"cmd_tunnel"
const COMMAND_BLOCK : StringName = &"cmd_block"
const COMMAND_BOOSTER : StringName = &"cmd_booster"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _selected_bot : WeakRef = weakref(null)

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	if _selected_bot.get_ref() == null and not _IsSlidOut():
		slide_out()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _IsSlidOut() -> bool:
	return not is_sliding() and not is_slid_in()

func _ToggleAction(bot : LilBot, action : StringName, data : Dictionary = {}) -> void:
	match bot.get_current_action():
		&"":
			bot.request_action(action, data)
		action:
			bot.clear_action()

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func select_bot(bot : LilBot) -> void:
	if bot != _selected_bot.get_ref():
		_selected_bot = weakref(bot)
		if bot != null:
			slide_in()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_btn_dig_pressed() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ToggleAction(bot, COMMAND_DIG)

func _on_btn_mine_pressed() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ToggleAction(bot, COMMAND_MINE)

func _on_btn_tunnel_pressed() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ToggleAction(bot, COMMAND_TUNNEL)

func _on_btn_block_pressed():
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ToggleAction(bot, COMMAND_BLOCK)

func _on_btn_booster_pressed() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	if bot.get_current_action() != COMMAND_BOOSTER:
		if bot.has_back_item(LilBot.BACK_ITEM_BOOSTER):
			bot.request_action(COMMAND_BOOSTER)
