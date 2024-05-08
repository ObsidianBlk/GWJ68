extends LilBotState

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("CMD Interact")
@export var idle_state : LilBotState = null


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------

func process_physics(delta : float) -> void:
	if _parent == null: return
	if not _parent.is_on_floor():
		transition_state(idle_state)
