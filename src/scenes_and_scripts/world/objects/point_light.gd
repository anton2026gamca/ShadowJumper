extends PointLight2D
class_name PointLight


@onready var animation_player: AnimationPlayer = $AnimationPlayer


var is_on: bool = true


func turn_off() -> void:
	animation_player.play("on-off")
	is_on = false
	await animation_player.animation_finished

func turn_on() -> void:
	animation_player.play("on-off", -1, -1.0, true)
	await animation_player.animation_finished
	is_on = true
