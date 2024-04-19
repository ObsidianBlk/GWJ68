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

func _ToggleDigAction(bot : LilBot, action : StringName, data : Dictionary = {}) -> void:
	# NOTE: No, I don't like this, but time is short and I don't have the time to think
	# of a more appropriate method to put the hat on and off.
	match bot.get_current_action():
		&"":
			bot.request_action(action, data)
			bot.show_hard_hat(true)
		action:
			bot.clear_action()
			bot.show_hard_hat(false)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func select_bot(bot : LilBot) -> void:
	var obot : LilBot = _selected_bot.get_ref()
	if bot != obot:
		if obot != null:
			obot.show_selector(false)
		_selected_bot = weakref(bot)
		if bot != null:
			bot.show_selector(true)
			slide_in()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_btn_dig_pressed() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ToggleDigAction(bot, COMMAND_DIG)

func _on_btn_mine_pressed() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ToggleDigAction(bot, COMMAND_MINE)

func _on_btn_tunnel_pressed() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ToggleDigAction(bot, COMMAND_TUNNEL)

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
