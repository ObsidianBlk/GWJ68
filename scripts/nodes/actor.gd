extends CharacterBody2D
class_name Actor

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
enum DIRECTION {Right, Up, Left, Down}
const DIRECTIONAL_THRESHOLD : float = 0.0001

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Actor")
@export var state_machine : FiniteStateMachine = null
@export var max_speed : float = 10.0



# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	if state_machine != null:
		state_machine.init(self)

#func _process(delta: float) -> void:
	#if not is_on_floor():
		#velocity.y = gravity
	#
	#if abs(_direction) < DIRECTIONAL_THRESHOLD:
		#velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
	#else:
		#velocity.x = _direction * max_speed
	#move_and_slide()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func request_state(state_name : StringName, data : Dictionary = {}) -> void:
	if state_machine != null:
		state_machine.change_state_by_name(state_name, data)

func request_action(state_name : StringName, data : Dictionary = {}) -> void:
	if state_machine == null: return
	if state_machine.has_state(state_name):
		state_machine.set_action_state(state_name, true, data)

func clear_action() -> void:
	if state_machine == null: return
	state_machine.clear_action_state()

func get_current_action() -> StringName:
	if state_machine != null:
		return state_machine.get_action_state_name()
	return &""

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



