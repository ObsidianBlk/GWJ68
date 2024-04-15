extends FiniteState


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _parent : LilBot = null

# ------------------------------------------------------------------------------
# "Virtual" Public Methods
# ------------------------------------------------------------------------------
func init(parent : Actor) -> void:
	if _parent != null: return
	if parent is LilBot:
		_parent = parent

func process_physics(delta : float) -> void:
	pass

func process_frame(delta : float) -> void:
	pass
