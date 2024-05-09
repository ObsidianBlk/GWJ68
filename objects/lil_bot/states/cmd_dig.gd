extends LilBotState

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Dig State")
@export var idle_state : FiniteState = null
@export var move_state : FiniteState = null
@export var shovel : ComponentShovel = null
@export var timer_interval : float = 0.5
@export var inactive_interval : float = 0.4

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _timer : float = 0.0

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _CanDig() -> bool:
	if shovel != null:
		return shovel.can_dig()
	return false

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func init(parent : Actor) -> int:
	var res : int = super.init(parent)
	if res == OK and shovel != null:
		shovel.diggable.connect(_on_shovel_diggable)
	return res

func enter(data : Dictionary = {}) -> void:
	_timer = timer_interval
	if _parent != null:
		_parent.velocity = Vector2.ZERO
		_parent.show_hard_hat(true)
	if shovel != null:
		if data.is_empty():
			shovel.rotation = 0.0
		elif "rotation" in data:
			shovel.rotation = data["rotation"]
	super.enter(data)

func exit() -> void:
	if inactive_interval <= 0.0: return
	await get_tree().create_timer(inactive_interval).timeout
	if _parent == null: return
	if _parent.get_current_action() != name:
		_parent.show_hard_hat(false)
	elif _parent.get_current_state() != name:
		_parent.show_hard_hat(false)
		_parent.clear_action()
	#if _parent.get_current_action() == name and _parent.get_current_state() != name:
	#	_parent.clear_action()
	super.exit()

func process_physics(delta : float) -> void:
	if _parent == null: return
	if not _parent.is_on_floor():
		transition_state(idle_state)
	else:
		if _CanDig():
			_parent.move_and_slide()
		else:
			transition_state(move_state)

func process_frame(delta : float) -> void:
	_timer -= (delta * LilBot.Get_Timer_Multiplier())
	if _timer <= 0.0:
		_timer += timer_interval
		if shovel != null:
			shovel.dig()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_shovel_diggable(diggable : bool) -> void:
	if _parent == null: return
	if _parent.get_current_action() == name:
		transition_state(self, {"rotation": shovel.rotation})
