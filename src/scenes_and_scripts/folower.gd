extends Node2D
class_name Follower


@export var folow: Node2D
@export var folow_speed: Vector2 = Vector2(500.0, 500.0)


func _process(delta: float) -> void:
	if folow:
		global_position.x = move_toward(global_position.x, folow.global_position.x, folow_speed.x * delta)
		global_position.y = move_toward(global_position.y, folow.global_position.y, folow_speed.x * delta)
