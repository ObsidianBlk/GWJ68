extends LilBotState


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Move State")
@export var idle_state : FiniteState = null
@export var air_state : FiniteState = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _direction : float = 0.0

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func enter(data : Dictionary = {}) -> void:
	print("On the ground")
	if abs(_direction) < Actor.DIRECTIONAL_THRESHOLD:
		_direction = -1.0 if _parent.initial_direction == Actor.DIRECTION.Left else 1.0


func process_physics(delta : float) -> void:
	if _parent == null: return
	if not _parent.is_on_floor():
		transition_state(air_state)
	if abs(_direction) > Actor.DIRECTIONAL_THRESHOLD:
		_parent.flip_h = _direction > 0.0
		_parent.velocity.x = _direction * _parent.max_speed
	else:
		_parent.velocity.x = move_toward(_parent.velocity.x, 0.0, 1000.0 * delta)
		if abs(_parent.velocity.x) < Actor.DIRECTIONAL_THRESHOLD:
			transition_state(idle_state)
	
	_parent.move_and_slide()
	if _parent.get_slide_collision_count() > 0:
		if abs(_parent.velocity.x) <= Actor.DIRECTIONAL_THRESHOLD:
			_direction *= -1.0


