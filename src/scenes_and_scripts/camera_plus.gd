extends Camera2D
class_name CameraPlus


@export_group("Follow")
@export var follow: Node2D
@export var follow_speed: Vector2 = Vector2(500.0, 500.0)
@export var limits: Dictionary[Vector2i, float]

@export_group("Screen Shake")
@export var shake_fade: float = 5
@export var distance_to_value: Curve

var after_death_mode: bool = false
var death_mode_velocity_x: float

var shake_value: float


func _ready() -> void:
	Helpers.camera = self

func _process(delta: float) -> void:
	if after_death_mode:
		global_position.x += death_mode_velocity_x * delta
		death_mode_velocity_x = move_toward(death_mode_velocity_x, 0, 180 * delta)
	elif follow:
		var x_before: float = global_position.x
		global_position.x = move_toward(global_position.x, follow.global_position.x, follow_speed.x * delta)
		global_position.y = move_toward(global_position.y, follow.global_position.y, follow_speed.y * delta)
	if Vector2i.UP in limits:
		global_position.y = max(global_position.y, limits[Vector2i.UP])
	if Vector2i.DOWN in limits:
		global_position.y = min(global_position.y, limits[Vector2i.DOWN])
	if Vector2i.LEFT in limits:
		global_position.x = max(global_position.x, limits[Vector2i.LEFT])
	if Vector2i.RIGHT in limits:
		global_position.x = min(global_position.x, limits[Vector2i.RIGHT])
	
	shake_value = lerpf(shake_value, 0, shake_fade * delta)
	offset = Vector2(randf_range(-shake_value, shake_value), randf_range(-shake_value, shake_value))


func shake(value: float, origin: Vector2) -> void:
	var distance: float = global_position.distance_to(origin)
	shake_value = value * distance_to_value.sample(distance)

func enter_death_mode(velocity_x: float) -> void:
	after_death_mode = true
	death_mode_velocity_x = velocity_x
