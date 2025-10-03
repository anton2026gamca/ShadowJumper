extends Sprite2D
class_name ParallaxLayer


@export var follow: CameraPlus
@export var move_speed_slowness: float = 3.0


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	global_position.x = follow.global_position.x / move_speed_slowness
