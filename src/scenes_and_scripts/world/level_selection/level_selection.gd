extends Node


@export var current_level: LevelSelectionLevel
@export var replay_controller: ReplayPlayerController

@onready var tilemap: TileMapLayer = $Level
@onready var camera: Follower = $Camera2D


func _ready() -> void:
	var new_level: LevelSelectionLevel = tilemap.get_node_or_null("Level" + str(Settings.last_visited_level))
	if new_level:
		current_level = new_level
		replay_controller.target.position = new_level.position + Vector2(0, -9)
		camera.position = replay_controller.target.position

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("level_up") and current_level:
		move_to_level(Vector2i.UP)
	if Input.is_action_just_pressed("level_down") and current_level:
		move_to_level(Vector2i.DOWN)
	if Input.is_action_just_pressed("level_left") and current_level:
		move_to_level(Vector2i.LEFT)
	if Input.is_action_just_pressed("level_right") and current_level:
		move_to_level(Vector2i.RIGHT)
	
	if Input.is_action_just_pressed("level_enter") and current_level and current_level.scene:
		Settings.last_visited_level = current_level.number
		get_tree().change_scene_to_packed(current_level.scene)


func move_to_level(dir: Vector2i) -> void:
	var new_level: LevelSelectionLevel = current_level.relationships[dir] if dir in current_level.relationships else null
	if not new_level:
		return
	replay_controller.replay_data = current_level.player_replays[dir] if dir in current_level.player_replays else null
	if not replay_controller.replay_data:
		return
	current_level = null
	replay_controller.start_replay()
	await replay_controller.replay_end
	current_level = new_level
