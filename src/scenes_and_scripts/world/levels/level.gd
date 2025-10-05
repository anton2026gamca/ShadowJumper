extends Node2D
class_name Level


@export var world_bottom_die_reason: String = "You fell out of the world!"
@export var camera: Camera2D
@export var energy_on_death: float = -100

signal player_died(reason: String)
signal level_defeated


func _ready() -> void:
	camera.make_current()

func _process(_delta: float) -> void:
	pass


func _on_world_bottom_limit_body_entered(body: Node2D) -> void:
	var death_component: DeathComponent = Helpers.find_child_by_type(body, DeathComponent)
	if death_component:
		death_component.die(world_bottom_die_reason)

func _on_player_died(reason: String) -> void:
	Settings.collected_energy += energy_on_death
	player_died.emit(reason)

func _on_finish_level_defeated() -> void:
	level_defeated.emit()
