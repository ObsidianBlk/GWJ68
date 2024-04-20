extends Node2D


# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal bot_spawned(num_spawned : int, spawn_total : int)

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const ANIM_OPENING : StringName = &"opening"
const ANIM_OPENED : StringName = &"opened"
const ANIM_CLOSING : StringName = &"closing"
const ANIM_CLOSED : StringName = &"closed"

const SPAWN_INTERVAL : float = 4.0
const SCENE_BOT : PackedScene = preload("res://objects/lil_bot/lil_bot.tscn")
const BOT_ACTION_SPAWN : StringName = &"spawn"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_category("BotSpawner")
@export var spawn_count : int = 0
@export var spawn_direction : Actor.DIRECTION = Actor.DIRECTION.Left
@export var spawn_container : Node2D = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _num_spawned : int = 0
var _spawning : bool = false
var _interval : float = SPAWN_INTERVAL

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _asprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var _marker : Marker2D = $Marker2D


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	bot_spawned.emit(_num_spawned, spawn_count)

func _process(delta : float) -> void:
	if not _spawning:
		if _interval > 0.0:
			_interval -= delta
		elif _num_spawned < spawn_count:
			spawn()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _SpawnBot() -> void:
	if spawn_container == null: return
	var bot = SCENE_BOT.instantiate()
	bot.initial_direction = spawn_direction
	spawn_container.add_child(bot)
	bot.global_position = _marker.global_position
	bot.request_action.call_deferred(BOT_ACTION_SPAWN)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func spawn() -> void:
	if spawn_container == null or _spawning: return
	_spawning = true
	
	_asprite.play(ANIM_OPENING)
	await _asprite.animation_finished
	_asprite.play(ANIM_OPENED)
	_SpawnBot()
	_num_spawned += 1
	bot_spawned.emit(_num_spawned, spawn_count)
	
	await get_tree().create_timer(1.0).timeout
	_asprite.play(ANIM_CLOSING)
	
	await _asprite.animation_finished
	_asprite.play(ANIM_CLOSED)
	_spawning = false
	_interval = SPAWN_INTERVAL

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

