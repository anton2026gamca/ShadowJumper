extends Node2D


@export var level_parent: Node2D
var current_level_number: int
var current_level_data: Dictionary
var current_level_scene: PackedScene
var current_level_node: Level
var is_in_level: bool = false
@onready var ui: LevelsUI = $UICanvasLayer/UI
@onready var level_ui_nodes: Node2D = $WorldCanvasLayer/LevelUINodes

@export var energy_on_player_death: float = -100

signal exit_level_signal(args: Array)


func _ready() -> void:
	ui.visible = false

func _process(_delta: float) -> void:
	if is_in_level:
		if Input.is_action_just_pressed("pause"):
			if get_tree().paused and ui.pause_menu.is_open: ui.resume()
			elif not get_tree().paused: ui.pause()
		_update_level_ui_nodes_postition.call_deferred()

func _update_level_ui_nodes_postition() -> void:
	if not current_level_node or not current_level_node.camera or not level_ui_nodes: return
	level_ui_nodes.position = (get_viewport_rect().size * 0.5) - (current_level_node.camera.get_screen_center_position() * 3)


func load_level(level: PackedScene, level_number: int, player_lives_override: int = 1) -> void:
	if Progress.total_collected_energy < 0: Progress.total_collected_energy = 0
	Progress.level_collected_energy = 0
	Progress.collected_energy_changed.emit()
	if Progress.total_rocks < 0: Progress.total_rocks = 0
	Progress.level_rocks = 0
	Progress.rocks_changed.emit()
	current_level_scene = level
	current_level_number = level_number
	var data: Variant = Helpers.dictionary_get_path(Progress.levels_data, [level_number, "data"])
	if Helpers.dictionary_get_path(Progress.levels_data, [level_number, "data"]) is Dictionary:
		current_level_data = data
	else:
		current_level_data = Helpers.dictionary_set_path(Progress.levels_data, [level_number, "data"], {})
	var node: Level = level.instantiate()
	current_level_node = node
	node.player_died.connect(player_died)
	node.level_defeated.connect(level_defeated)
	is_in_level = true
	ui.camera = node.camera
	ui.reset()
	ui.visible = true
	level_parent.add_child.call_deferred(node)
	await get_tree().process_frame
	PerformanceOptimizer.apply_all_optimizations(current_level_node)
	level_ui_nodes.scale = Vector2(1, 1)
	for ui_node: Control in node.ui_nodes:
		if not ui_node: continue
		ui_node.reparent(level_ui_nodes)
	level_ui_nodes.scale = Vector2(3, 3)
	_update_level_ui_nodes_postition()
	if player_lives_override > 0:
		Helpers.player.health_component.lives = player_lives_override

func exit_level(args: Array) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	is_in_level = false
	level_parent.remove_child(current_level_node)
	current_level_node.queue_free()
	current_level_node = null
	exit_level_signal.emit(args)
	ui.visible = false
	for child: Node in level_ui_nodes.get_children():
		level_ui_nodes.remove_child(child)
		child.queue_free()

func player_died(reason: String) -> void:
	if not is_in_level:
		return
	is_in_level = false
	Progress.collect_energy(energy_on_player_death)
	ui.open_respawn_menu(reason)

func level_defeated() -> void:
	if not is_in_level:
		return
	var player_lives: int = Helpers.player.health_component.lives
	is_in_level = false
	ui.full_screen_text.visible = true
	ui.full_screen_text.text = tr("UI_LEVEL_DEFEATED") + "\n"
	ui.full_screen_text.text += "[code]\n"
	var energy_color: String = Helpers.get_energy_level_color(Progress.level_collected_energy).to_html(false)
	ui.full_screen_text.text += tr("STATS_COLLECTED_ENERGY_THIS_RUN") + "[color=#" + energy_color + "]" + ("+" if Progress.level_collected_energy > 0 else "") + str(int(Progress.level_collected_energy)) + tr("STATS_ENERGY_SUFFIX") + "[/color]\n"
	var rocks_color: String = "lime" if Progress.level_rocks > 0 else "yellow"
	ui.full_screen_text.text += tr("STATS_ROCKS_THIS_RUN") + "[color=" + rocks_color + "]" + ("+" if Progress.level_rocks > 0 else "") + str(int(Progress.level_rocks)) + tr("STATS_ROCKS_SUFFIX") + "[/color]\n"
	ui.full_screen_text.text += "[/code]"
	ui.full_screen_text.visible_characters = 0
	ui.full_screen_text.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_tween().tween_property(ui.full_screen_text, "visible_characters", len(ui.full_screen_text.get_parsed_text()), 1)
	$LevelDefeatedSFX.play()
	await get_tree().create_timer(3).timeout
	ui.full_screen_text.visible = false
	ui.full_screen_text.process_mode = Node.PROCESS_MODE_PAUSABLE
	exit_level([true, player_lives])

func reload_level() -> void:
	level_parent.remove_child(current_level_node)
	current_level_node.queue_free()
	current_level_node = null
	load_level(current_level_scene, current_level_number, true)
	Progress._save()

func hitstop(time: float) -> void:
	get_tree().paused = true
	await get_tree().create_timer(time).timeout
	if not is_in_level:
		return
	get_tree().paused = false
