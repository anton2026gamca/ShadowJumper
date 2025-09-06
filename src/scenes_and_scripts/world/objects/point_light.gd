extends Sprite2D
class_name PointLight


@onready var light: PointLight2D = $PointLight2D
@onready var animation_player: AnimationPlayer = $PointLight2D/AnimationPlayer


var is_on: bool = true
var time: float


func off() -> void:
	animation_player.play("on-off")
	is_on = false
	await animation_player.animation_finished
	animation_player.play("light")

func on() -> void:
	animation_player.play("on-off", -1, -1.0, true)
	is_on = true
	await animation_player.animation_finished
	animation_player.play("light")
