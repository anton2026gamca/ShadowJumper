extends Node2D
class_name LevelLoaderClass


@export var level_parent: Node
@export var current_level: PackedScene
@export var current_level_node: Level
var is_in_level: bool = false
@onready var ui: LevelsUI = $UICanvasLayer/UI

signal exit_level_signal(defeated: bool)


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and is_in_level:
		if get_tree().paused and ui.pause_menu.is_open: ui.resume()
		elif not get_tree().paused: ui.pause()


func load_level(level: PackedScene, skip_story: bool = false) -> void:
	current_level = level
	var node: Level = level.instantiate()
	current_level_node = node
	node.player_died.connect(player_died)
	node.level_defeated.connect(level_defeated)
	level_parent.add_child.call_deferred(node)
	is_in_level = true
	ui.camera = node.camera
	ui.reset()
	if not skip_story and ui.story.parts.has(node.story_in_beginning):
		ui.story.play_part(node.story_in_beginning)

func exit_level(defeated: bool = false) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	is_in_level = false
	level_parent.remove_child(current_level_node)
	current_level_node.queue_free()
	current_level_node = null
	exit_level_signal.emit(defeated)

func player_died(reason: String) -> void:
	if not is_in_level:
		return
	ui.open_respawn_menu(reason)

func level_defeated() -> void:
	if not is_in_level:
		return
	is_in_level = false
	ui.full_screen_text.visible = true
	ui.full_screen_text.text = "LEVEL\nDEFEATED !!!"
	ui.full_screen_text.visible_characters = 0
	ui.full_screen_text.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_tween().tween_property(ui.full_screen_text, "visible_characters", len("LEVEL\nDEFEATED !!!"), 0.5)
	$LevelDefeatedSFX.play()
	await get_tree().create_timer(3).timeout
	ui.full_screen_text.visible = false
	ui.full_screen_text.process_mode = Node.PROCESS_MODE_PAUSABLE
	exit_level(true)

func reload_level() -> void:
	level_parent.remove_child(current_level_node)
	current_level_node.queue_free()
	current_level_node = null
	load_level(current_level)
