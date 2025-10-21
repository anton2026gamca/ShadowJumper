extends Animal
class_name GroundAnimal


@export var player_die_reason: String

@export_group("Behaviour")
@export var walk_speed: float
@export var run_speed: float
@export_group("Behaviour/Searching")
@export var chance_to_rotate: float = 0.005
@export var rotate_down_time: float = 2.0
@export_group("Behaviour/Attacking")
@export var attack_screen_shake_value: float = 5.0
@export var chance_to_give_up: float = 0.003
@export var give_up_time: float = 3.0
@export var attack_hitstop: float = 0.2
@export_group("Behaviour/Death")
@export var spawn_powerup_on_death: PackedScene

const POWERUP_OBJECT: PackedScene = preload("res://scenes_and_scripts/world/objects/powerup_object.tscn")
@onready var health_component: HealthComponent = $HealthComponent
@onready var energy_collector_component: EnergyCollectorComponent = $EnergyCollectorComponent
@onready var death_component: DeathComponent = $DeathComponent


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_death_component_die(reason: String, instant_kill: bool = false) -> void:
	if health_component.lives == 0: return
	health_component.lives -= 1
	if reason == "You fell from too high!": health_component.lives = 0
	if health_component.lives != 0: return
	remove_child(death_component)
	death_component.queue_free()
	await get_tree().process_frame
	if reason != "reason::not_spawned":
		if spawn_powerup_on_death:
			Helpers.spawn_powerup(get_parent(), spawn_powerup_on_death, global_position)
		energy_collector_component.collect("kill")
	await super._on_death_component_die(reason, instant_kill)


func get_player_die_reason() -> String:
	return player_die_reason

func get_walk_speed() -> float:
	return walk_speed

func get_run_speed() -> float:
	return run_speed
