extends Node2D


@export var current_level: LevelSelectionLevel
@export var replay_controller: ReplayPlayerController


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and current_level:
		move_to_level(Vector2i.UP)
	if Input.is_action_just_pressed("ui_down") and current_level:
		move_to_level(Vector2i.DOWN)
	if Input.is_action_just_pressed("ui_left") and current_level:
		move_to_level(Vector2i.LEFT)
	if Input.is_action_just_pressed("ui_right") and current_level:
		move_to_level(Vector2i.RIGHT)
	
	if Input.is_action_just_pressed("ui_accept") and current_level and current_level.scene:
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
	print("Moving to level in direction: ", dir)
	await replay_controller.replay_end
	current_level = new_level
