extends Animal
class_name Bee


@export var fly_speed: float = 250.0
@export var attack_min_height_diff: float = 100.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_death_component_die(reason: String) -> void:
	state_machine.enabled = false
	sprite.play("die")
	collision_layer = 0
	await sprite.animation_finished
	get_parent().remove_child(self)
	queue_free()
