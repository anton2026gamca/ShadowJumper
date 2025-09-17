extends Animal
class_name Bee


@export var fly_speed: float = 250.0


func _physics_process(delta: float) -> void:
	move_and_slide()
