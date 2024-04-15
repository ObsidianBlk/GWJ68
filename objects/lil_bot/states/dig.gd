extends LilBotState

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Dig State")
@export var idle_state : FiniteState = null
@export var shovel : ComponentShovel = null
@export var timer_interval : float = 0.5

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _timer : float = 0.0

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary = {}) -> void:
	_timer = timer_interval
	if _parent != null:
		_parent.velocity = Vector2.ZERO
	if shovel != null:
		if data.is_empty():
			shovel.rotation = 0.0
		elif "rotation" in data:
			shovel.rotation = data["rotation"]

func process_physics(delta : float) -> void:
	if _parent == null: return
	if not _parent.is_on_floor():
		transition_state(idle_state)
	else:
		_parent.move_and_slide()

func process_frame(delta : float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		_timer += timer_interval
		if shovel != null:
			shovel.dig()


