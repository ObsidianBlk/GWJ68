extends SlideoutMarginContainer

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const GROUP_LILBOT : StringName = &"lilbot"

const COMMAND_DIG : StringName = &"cmd_dig"
const COMMAND_MINE : StringName = &"cmd_mine"
const COMMAND_TUNNEL : StringName = &"cmd_tunnel"
const COMMAND_BLOCK : StringName = &"cmd_block"
const COMMAND_INTERACT : StringName = &"cmd_interact"
const COMMAND_BOOSTER : StringName = &"cmd_booster"
const COMMAND_BUILD : StringName = &"cmd_build"

const HARDHAT_ACTIONS : Array[StringName] = [
	COMMAND_DIG,
	COMMAND_MINE,
	COMMAND_TUNNEL
]

const LOCK_COMMAND : StringName = COMMAND_BOOSTER

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _selected_bot : WeakRef = weakref(null)
var _cmdbtns : Dictionary = {}
var _can_interact : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _btn_dig: TextureButton = %BTNDig
@onready var _btn_mine: TextureButton = %BTNMine
@onready var _btn_tunnel: TextureButton = %BTNTunnel
@onready var _btn_block: TextureButton = %BTNBlock
@onready var _btn_interact: TextureButton = %BTNInteract
@onready var _btn_booster: TextureButton = %BTNBooster
@onready var _btn_build: TextureButton = %BTNBuild
@onready var _btn_pause: TextureButton = %BTNPause
@onready var _btn_kill_all: Button = %BTN_KillAll


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	Game.bots_saved.connect(_on_bots_saved)
	Relay.requested.connect(_on_relay_requested)
	_cmdbtns[COMMAND_DIG] = {"btn":_btn_dig, "active":true}
	_cmdbtns[COMMAND_MINE] = {"btn":_btn_mine, "active":true}
	_cmdbtns[COMMAND_TUNNEL] = {"btn":_btn_tunnel, "active":true}
	_cmdbtns[COMMAND_BLOCK] = {"btn":_btn_block, "active":true}
	_cmdbtns[COMMAND_INTERACT] = {"btn":_btn_interact, "active":false}
	_cmdbtns[COMMAND_BOOSTER] = {"btn":_btn_booster, "active":false}
	_cmdbtns[COMMAND_BUILD] = {"btn":_btn_build, "active":false}

func _physics_process(_delta: float) -> void:
	if _selected_bot.get_ref() == null and not _IsSlidOut():
		slide_out()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _IsSlidOut() -> bool:
	return not is_sliding() and not is_slid_in()


func _ChangeActiveAction(bot : LilBot, action : StringName, enable : bool, data : Dictionary = {}) -> void:
	var is_action : bool = action == bot.get_current_action()
	if is_action and not enable:
		bot.clear_action()
		#if HARDHAT_ACTIONS.find(action) >= 0:
			#bot.show_hard_hat(false)
	if not is_action and enable:
		bot.request_action(action, data)
		#if HARDHAT_ACTIONS.find(action) >= 0:
			#bot.show_hard_hat(true)


func _ConnectSelectedBot() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	bot.show_selector(true)
	if not bot.state_changed.is_connected(_on_selected_bot_state_changed):
		bot.state_changed.connect(_on_selected_bot_state_changed)
	if not bot.action_state_changed.is_connected(_on_selected_bot_action_state_changed):
		bot.action_state_changed.connect(_on_selected_bot_action_state_changed)
	if not bot.pickup_obtained.is_connected(_on_selected_bot_pickup_state_changed.bind(true)):
		bot.pickup_obtained.connect(_on_selected_bot_pickup_state_changed.bind(true))
	if not bot.pickup_lost.is_connected(_on_selected_bot_pickup_state_changed.bind(false)):
		bot.pickup_lost.connect(_on_selected_bot_pickup_state_changed.bind(false))
	if not bot.interact_changed.is_connected(_on_interact_changed):
		bot.interact_changed.connect(_on_interact_changed)
	
	_on_selected_bot_action_state_changed(bot.get_current_action())
	_on_selected_bot_pickup_state_changed(
		LilBot.BACK_ITEM_BOOSTER,
		bot.has_back_item(LilBot.BACK_ITEM_BOOSTER)
	)
	_on_selected_bot_pickup_state_changed(
		LilBot.BACK_ITEM_PART,
		bot.has_back_item(LilBot.BACK_ITEM_PART)
	)
	_on_interact_changed(bot.can_interact())


func _DisconnectSelectedBot() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	bot.show_selector(false)
	if bot.state_changed.is_connected(_on_selected_bot_state_changed):
		bot.state_changed.disconnect(_on_selected_bot_state_changed)
	if bot.action_state_changed.is_connected(_on_selected_bot_action_state_changed):
		bot.action_state_changed.disconnect(_on_selected_bot_action_state_changed)
	if bot.pickup_obtained.is_connected(_on_selected_bot_pickup_state_changed.bind(true)):
		bot.pickup_obtained.disconnect(_on_selected_bot_pickup_state_changed.bind(true))
	if bot.pickup_lost.is_connected(_on_selected_bot_pickup_state_changed.bind(false)):
		bot.pickup_lost.disconnect(_on_selected_bot_pickup_state_changed.bind(false))
	if bot.interact_changed.is_connected(_on_interact_changed):
		bot.interact_changed.disconnect(_on_interact_changed)
	_LockCommands(true)

func _LockCommands(lock : bool) -> void:
	for cmd : StringName in _cmdbtns:
		if lock or _cmdbtns[cmd].active:
			_cmdbtns[cmd].btn.disabled = lock

func _CheckBotHardHat() -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot != null:
		var action : StringName = bot.get_current_action()
		bot.show_hard_hat(HARDHAT_ACTIONS.find(action) >= 0)

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
			_LockCommands(false)
			slide_in()
		else:
			_LockCommands(true)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_relay_requested(action : StringName, payload : Dictionary = {}) -> void:
	if action == &"lock_commands":
		if "lock" in payload and typeof(payload["lock"]) == TYPE_BOOL:
			_LockCommands(payload["lock"])

func _on_selected_bot_state_changed(state_name : StringName) -> void:
	pass

func _on_selected_bot_action_state_changed(state_name : StringName) -> void:
	_CheckBotHardHat()
	for cmd : StringName in _cmdbtns.keys():
		var btn : TextureButton = _cmdbtns[cmd].btn
		if cmd == state_name:
			btn.button_pressed = true
			btn.disabled = false
		else:
			btn.button_pressed = false
			if state_name == LOCK_COMMAND:
				btn.disabled = true
			else:
				btn.disabled = not _cmdbtns[cmd].active

func _on_selected_bot_pickup_state_changed(item_name : StringName, obtained : bool) -> void:
	match item_name:
		LilBot.BACK_ITEM_BOOSTER:
			_cmdbtns[COMMAND_BOOSTER].active = obtained
			_cmdbtns[COMMAND_BOOSTER].btn.disabled = not obtained
		LilBot.BACK_ITEM_PART:
			_cmdbtns[COMMAND_BUILD].active = obtained
			_cmdbtns[COMMAND_BUILD].btn.disabled = not obtained

func _on_interact_changed(can_interact : bool) -> void:
	_cmdbtns[COMMAND_INTERACT].btn.disabled = not can_interact

func _on_bots_saved(saved : int, required : int) -> void:
	_btn_kill_all.visible = saved >= required

func _on_btn_dig_toggled(toggled_on: bool) -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ChangeActiveAction(bot, COMMAND_DIG, toggled_on)

	
func _on_btn_mine_toggled(toggled_on: bool) -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ChangeActiveAction(bot, COMMAND_MINE, toggled_on)


func _on_btn_tunnel_toggled(toggled_on: bool) -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ChangeActiveAction(bot, COMMAND_TUNNEL, toggled_on)


func _on_btn_block_toggled(toggled_on: bool) -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ChangeActiveAction(bot, COMMAND_BLOCK, toggled_on)

func _on_btn_interact_toggles(toggled_on : bool) -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	_ChangeActiveAction(bot, COMMAND_INTERACT, toggled_on)

func _on_btn_booster_toggled(toggled_on: bool) -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	if bot.get_current_action() != COMMAND_BOOSTER and toggled_on:
		if bot.has_back_item(LilBot.BACK_ITEM_BOOSTER):
			bot.request_action(COMMAND_BOOSTER)

func _on_btn_build_toggled(toggled_on: bool) -> void:
	var bot : LilBot = _selected_bot.get_ref()
	if bot == null: return
	var action_in_use : bool = bot.get_current_action() == COMMAND_BUILD
	if toggled_on:
		if not action_in_use and bot.has_back_item(LilBot.BACK_ITEM_PART):
			bot.request_action(COMMAND_BUILD)
		else:
			# Can't activate booster, so unpress ourselves
			_btn_booster.button_pressed = false
	elif not toggled_on and action_in_use:
		bot.clear_action()

func _on_btn_pause_pressed() -> void:
	var is_paused : bool = Level.Is_Paused()
	Level.Pause_Level(not is_paused)

func _on_btn_pause_toggled(toggled_on: bool) -> void:
	Level.Pause_Level(toggled_on)
	_LockCommands(toggled_on)

func _on_btn_kill_all_pressed() -> void:
	for bot : Node in get_tree().get_nodes_in_group(GROUP_LILBOT):
		if bot is LilBot:
			bot.request_action(&"boom")

