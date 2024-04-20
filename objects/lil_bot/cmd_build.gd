extends LilBotState


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("CMD Build")
@export var idle_state : FiniteState = null
@export var move_state : FiniteState = null
@export var build_delay : float = 1.0
@export var build_position_marker : Marker2D = null
@export var raycast : RayCast2D = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _delay : float = 0.0
var _built : bool = false

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------

func _physics_process(delta: float) -> void:
	if _parent == null or raycast == null: return
	if not _parent.is_on_floor(): return
	if _parent.get_current_action() != self.name: return
	var is_current_state : bool = _parent.get_current_state() == self.name
	if not is_current_state and not raycast.is_colliding():
		_delay = build_delay
		transition_to_action()
	elif is_current_state and raycast.is_colliding():
		transition_state(move_state)

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary) -> void:
	if raycast == null or not _parent.has_back_item(LilBot.BACK_ITEM_PART):
		_parent.clear_action()
	_built = false
	_delay = build_delay

func process_physics(delta : float) -> void:
	if _parent == null: return
	if not _parent.is_on_floor():
		transition_state(idle_state)
	elif not _built:
		if _delay > 0.0:
			_delay -= delta
		else:
			Level.Build_At(build_position_marker.global_position)
			_parent.use_part()
			if _parent.get_part_count() <= 0:
				_parent.enable_back_item(LilBot.BACK_ITEM_PART, false)
				_parent.clear_action()
			_built = true

