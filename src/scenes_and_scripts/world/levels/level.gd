extends Node2D
class_name Level


@export var world_bottom_die_reason: String = "DEATH_FELL_OUT_OF_WORLD"
@export var camera: Camera2D
@export var ui_nodes: Array[Control] = []

@onready var remote_transform: RemoteTransform2D = $Camera2D/RemoteTransform2D


var number: int

signal player_died(reason: String)
signal level_defeated


func _ready() -> void:
	if Engine.is_editor_hint():
		camera.make_current()
	camera.get_global_transform_with_canvas()


func _on_world_bottom_limit_body_entered(body: Node2D) -> void:
	var death_component: DeathComponent = Helpers.find_child_by_type(body, DeathComponent)
	if death_component:
		death_component.die(world_bottom_die_reason, true)

func _on_player_died(reason: String) -> void:
	player_died.emit(reason)

func _on_finish_level_defeated() -> void:
	level_defeated.emit()
