extends CharacterBody2D
class_name Animal


@export_range(0.0, 1.0) var chance_to_spawn: float = 1.0


func _ready() -> void:
	if randf() > chance_to_spawn:
		_on_death_component_die("reason::not_spawned")

func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_death_component_die(reason: String) -> void:
	get_parent().remove_child.call_deferred(self)
	queue_free()
