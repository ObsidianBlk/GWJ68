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
const COMMAND_BUILD : StringName = &"cmd_build"

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
	if action == bot.get_current_action():
		bot.clear_action()
	else:
		bot.request_action(action, data)
	#match bot.get_current_action():
		#&"":
			#bot.request_action(action, data)
		#action:
			#bot.clear_action()

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

func _ConnectSelectedBot() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	bot.show_selector(true)
	if not bot.state_changed.is_connected(_on_selected_bot_state_changed):
		bot.state_changed.connect(_on_selected_bot_state_changed)
	if not bot.action_state_changed.is_connected(_on_selected_bot_action_state_changed):
		bot.action_state_changed.connect(_on_selected_bot_action_state_changed)

func _DisconnectSelectedBot() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	bot.show_selector(false)
	if bot.state_changed.is_connected(_on_selected_bot_state_changed):
		bot.state_changed.disconnect(_on_selected_bot_state_changed)
	if bot.action_state_changed.is_connected(_on_selected_bot_action_state_changed):
		bot.action_state_changed.disconnect(_on_selected_bot_action_state_changed)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func select_bot(bot : LilBot) -> void:
	var obot : LilBot = _selected_bot.get_ref()
	if bot != obot:
		_DisconnectSelectedBot()
		_selected_bot = weakref(bot)
		_ConnectSelectedBot()
		if bot != null:
			slide_in()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_selected_bot_state_changed(state_name : StringName) -> void:
	pass

func _on_selected_bot_action_state_changed(state_name : StringName) -> void:
	pass

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

func _on_btn_build_pressed() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	var action_in_use : bool = bot.get_current_action() == COMMAND_BUILD
	if not action_in_use and bot.has_back_item(LilBot.BACK_ITEM_PART):
		bot.request_action(COMMAND_BUILD)
	elif action_in_use:
		bot.clear_action()

func _on_btn_pause_pressed() -> void:
	var is_paused : bool = Level.Is_Paused()
	Level.Pause_Level(not is_paused)
