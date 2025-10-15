extends Node2D


@export var ui: LevelSelectionUi

@export var start_level: LevelSelectionLevel
var current_level: LevelSelectionLevel
@export var replay_controller: ReplayPlayerController

@export var camera: CameraPlus
@export var player: Player


func _ready() -> void:
	current_level = start_level
	for level: LevelSelectionLevel in find_children("", "LevelSelectionLevel"):
		if level != start_level:
			level.visible = false
	for key: int in Progress.levels_data.keys():
		if not Progress.levels_data[key].get("defeated", false):
			continue
		var level: LevelSelectionLevel = find_level_by_number(key)
		if not level: continue
		level.visible = true
		level.mark_completed()
		for neighbour_level: LevelSelectionLevel in level.relationships.values():
			if not neighbour_level: continue
			neighbour_level.visible = true
	var new_level: LevelSelectionLevel = find_level_by_number(Progress.last_level)
	if new_level: current_level = new_level
	replay_controller.target.position = current_level.position + Vector2(0, -9)
	camera.position = replay_controller.target.position
	Helpers.camera = camera
	player.health_component.lives = Progress.player_lives

func _process(_delta: float) -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed("debug_toggle_levels"):
		_debug_toggle_all_levels_on()
	
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ladder_climb_up")) and current_level:
		move_to_level(Vector2i.UP)
	if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ladder_climb_down")) and current_level:
		move_to_level(Vector2i.DOWN)
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("move_left")) and current_level:
		move_to_level(Vector2i.LEFT)
	if (Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("move_right")) and current_level:
		move_to_level(Vector2i.RIGHT)
	
	if Input.is_action_just_released("ui_accept") and current_level and current_level.scene:
		enter_level()
	
	if Input.is_action_just_pressed("pause"):
		Helpers.main_menu.pause()


func find_level_by_number(num: int) -> LevelSelectionLevel:
	var levels: Array[Node] = find_children("", "LevelSelectionLevel")
	var index: int = levels.find_custom(func(level: LevelSelectionLevel) -> bool: return level.number == num)
	if index < 0:
		return null
	return levels[index]

func enter_level() -> void:
	Progress.player_lives = player.health_component.lives
	var player_lives_before: int = player.health_component.lives
	if not LevelLoader is LevelLoaderClass:
		return
	var parent: Node = get_parent()
	LevelLoader.load_level(current_level.scene, current_level.number, player.health_component.lives)
	get_tree().current_scene = LevelLoader
	ui.visible = false
	parent.remove_child(self)
	var args: Array = await LevelLoader.exit_level_signal
	parent.add_child(self)
	ui.visible = true
	get_tree().current_scene = Helpers.main_menu
	camera.make_current()
	Helpers.camera = camera
	var defeated: bool = args[0] if len(args) >= 1 and args[0] is bool else false
	if defeated:
		if not current_level.is_completed:
			current_level.mark_completed()
			Helpers.dictionary_set_path(Progress.levels_data, [current_level.number, "defeated"], true)
			for level: LevelSelectionLevel in current_level.relationships.values():
				if not level:
					continue
				level.visible = true
				if current_level.number + 1 == level.number:
					move_to_level(current_level.relationships.find_key(level))
		var lives: int = args[1] if len(args) >= 2 and args[1] is int else 1
		player.health_component.lives = lives
	else:
		player.health_component.lives = 1
		var cancel_progress: bool = args[1] if len(args) >= 2 and args[1] is bool else false
		if cancel_progress:
			Progress.collect_energy(-Progress.level_collected_energy)
			Progress.collect_rocks(-Progress.level_rocks)
			player.health_component.lives = player_lives_before
	Progress.player_lives = player.health_component.lives
	ui.collected_energy_animation()
	Progress._save()

func move_to_level(dir: Vector2i) -> void:
	var new_level: LevelSelectionLevel = current_level.relationships[dir] if dir in current_level.relationships else null
	if not new_level or not new_level.visible:
		return
	replay_controller.replay_data = current_level.player_replays[dir] if dir in current_level.player_replays else null
	if not replay_controller.replay_data:
		return
	current_level = null
	replay_controller.start_replay()
	await replay_controller.replay_ended
	current_level = new_level
	Progress.last_level = new_level.number
	Progress._save()

func _debug_toggle_all_levels_on() -> void:
	if not OS.is_debug_build():
		return
	var all: Array[Node] = find_children("", "LevelSelectionLevel")
	for lvl: LevelSelectionLevel in all:
		lvl.visible = true
	if ui:
		ui.debug_text.text = ui.debug_text.text.replace("Press [color=lightblue]L[/color] to unlock all levels", "All levels ulocked!")
