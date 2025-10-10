extends CharacterBody2D
class_name Animal


@export_range(0.0, 1.0) var chance_to_spawn: float = 1.0
@onready var state_machine: StateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if randf() > chance_to_spawn:
		_on_death_component_die("reason::not_spawned")

func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_death_component_die(reason: String, instant_kill: bool = false) -> void:
	state_machine.enabled = false
	animation_player.play("die")
	await animation_player.animation_finished
	get_parent().remove_child.call_deferred(self)
	queue_free()
