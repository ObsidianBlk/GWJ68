extends Node2D
class_name World

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Static Variables
# ------------------------------------------------------------------------------


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
	if Settings.load() != OK:
		Settings.request_reset()
		Settings.save()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Public Static Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



