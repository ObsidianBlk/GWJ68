extends Node2D


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("Bobbing Lil Botty")
@export var hover_curve : Curve = null
@export var hover_multiplier : float = 1.0
@export var hover_duration : float = 4.0


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _animating : bool = false
var _tweening_hover : bool = false
var _base_position : Vector2 = Vector2.ZERO


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _sprite_faceplate : Sprite2D = $Sprite_Faceplate


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_base_position = _sprite_faceplate.position
	start()

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func start() -> void:
	if _tweening_hover or _sprite_faceplate == null or hover_curve == null: return
	_tweening_hover = true
	_animating = true
	
	var tween : Tween = create_tween()
	tween.tween_method(_on_update_animation, 0.0, 1.0, hover_duration)
	await tween.finished
	_tweening_hover = false
	if _animating:
		start.call_deferred()

func stop() -> void:
	_animating = false

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_update_animation(value : float) -> void:
	if _sprite_faceplate == null or hover_curve == null: return
	#var y : float = hover_curve.sample(value) * hover_multiplier
	#print("Y: ", y)
	_sprite_faceplate.position = _base_position + Vector2(
		0.0,
		hover_curve.sample(value) * hover_multiplier
	)

