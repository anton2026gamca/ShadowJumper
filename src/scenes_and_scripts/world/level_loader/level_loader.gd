extends Node2D
class_name LevelLoaderClass


@export var level_parent: Node
@export var current_level: PackedScene
@export var current_level_node: Level
var is_in_level: bool = false
@onready var ui: LevelsUI = $UICanvasLayer/UI

@export var energy_on_player_death: float = -100

signal exit_level_signal(args: Array)


func _ready() -> void:
	ui.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and is_in_level:
		if get_tree().paused and ui.pause_menu.is_open: ui.resume()
		elif not get_tree().paused: ui.pause()


func load_level(level: PackedScene, player_lives_override: int = 1) -> void:
	if Settings.total_collected_energy < 0: Settings.total_collected_energy = 0
	Settings.level_collected_energy = 0
	Settings.collected_energy_changed.emit()
	if Settings.total_rocks < 0: Settings.total_rocks = 0
	Settings.level_rocks = 0
	Settings.rocks_changed.emit()
	current_level = level
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

func player_died(reason: String) -> void:
	if not is_in_level:
		return
	Settings.collect_energy(energy_on_player_death)
	ui.open_respawn_menu(reason)

func level_defeated() -> void:
	if not is_in_level:
		return
	var player_lives: int = Helpers.player.health_component.lives
	is_in_level = false
	ui.full_screen_text.visible = true
	ui.full_screen_text.text = "LEVEL\nDEFEATED !!!\n"
	ui.full_screen_text.text += "[code]\n"
	var energy_color: String = Helpers.get_energy_level_color(Settings.level_collected_energy).to_html(false)
	ui.full_screen_text.text += "Collected energy this run: [color=#" + energy_color + "]" + ("+" if Settings.level_collected_energy > 0 else "") + str(int(Settings.level_collected_energy)) + " E[/color]\n"
	var rocks_color: String = "lime" if Settings.level_rocks > 0 else "yellow"
	ui.full_screen_text.text += "Rocks this run: [color=" + rocks_color + "]" + ("+" if Settings.level_rocks > 0 else "") + str(int(Settings.level_rocks)) + " R[/color]\n"
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
	load_level(current_level, true)
	Settings._save()
