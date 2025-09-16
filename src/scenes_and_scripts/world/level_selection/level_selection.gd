extends Node2D


@export var start_level: LevelSelectionLevel
var current_level: LevelSelectionLevel
@export var replay_controller: ReplayPlayerController

@onready var tilemap: TileMapLayer = $Level
@onready var camera: Follower = $Camera2D

@export var debug_mode: bool = false


func _ready() -> void:
	current_level = start_level
	for level: LevelSelectionLevel in find_children("", "LevelSelectionLevel"):
		if level != start_level:
			level.visible = debug_mode
	for path: NodePath in Settings.beated_levels:
		var level: Node = get_node(path)
		if not level is LevelSelectionLevel: continue
		level.visible = true
		level.mark_completed()
		for neighbour_level: LevelSelectionLevel in level.relationships.values():
			if not neighbour_level: continue
			neighbour_level.visible = true
	var new_level: Node = get_node_or_null(Settings.last_level)
	if new_level is LevelSelectionLevel:
		current_level = new_level
	replay_controller.target.position = current_level.position + Vector2(0, -9)
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
	
	if Input.is_action_just_released("level_enter") and current_level and current_level.scene:
		enter_level()


func enter_level() -> void:
	Settings.last_entered_level = get_path_to(current_level)
	if not LevelLoader is LevelLoaderClass:
		return
	var parent: Node = get_parent()
	parent.remove_child(self)
	LevelLoader.load_level(current_level.scene)
	var defeated: bool = await LevelLoader.exit_level_signal
	parent.add_child(self)
	if defeated:
		current_level.mark_completed()
		Settings.beated_levels.append(get_path_to(current_level))
		for level: LevelSelectionLevel in current_level.relationships.values():
			if not level:
				continue
			level.visible = true

func move_to_level(dir: Vector2i) -> void:
	var new_level: LevelSelectionLevel = current_level.relationships[dir] if dir in current_level.relationships else null
	if not new_level or not new_level.visible:
		return
	replay_controller.replay_data = current_level.player_replays[dir] if dir in current_level.player_replays else null
	if not replay_controller.replay_data:
		return
	current_level = null
	replay_controller.start_replay()
	await replay_controller.replay_end
	current_level = new_level
	Settings.last_level = get_path_to(new_level)
