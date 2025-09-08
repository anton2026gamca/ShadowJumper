extends Sprite2D
class_name Mushroom


@onready var point_light: PointLight = $PointLight

@export var down_time: float = 5.0
var hit_val: int = 0


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func hit() -> void:
	if point_light.is_on:
		point_light.turn_off()
	hit_val += 1
	var my_hit_val: float = hit_val
	await get_tree().create_timer(down_time).timeout
	if hit_val == my_hit_val:
		point_light.turn_on()
		hit_val = 0
