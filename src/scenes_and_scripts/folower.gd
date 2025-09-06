extends Node2D
class_name Follower


@export var folow: Node2D
@export var folow_speed: Vector2 = Vector2(500.0, 500.0)
@export var limits: Dictionary[Vector2i, float]


func _process(delta: float) -> void:
	if folow:
		global_position.x = move_toward(global_position.x, folow.global_position.x, folow_speed.x * delta)
		global_position.y = move_toward(global_position.y, folow.global_position.y, folow_speed.y * delta)
		if Vector2i.UP in limits:
			global_position.y = max(global_position.y, limits[Vector2i.UP])
		if Vector2i.DOWN in limits:
			global_position.y = min(global_position.y, limits[Vector2i.DOWN])
		if Vector2i.LEFT in limits:
			global_position.x = max(global_position.x, limits[Vector2i.LEFT])
		if Vector2i.RIGHT in limits:
			global_position.x = min(global_position.x, limits[Vector2i.RIGHT])
