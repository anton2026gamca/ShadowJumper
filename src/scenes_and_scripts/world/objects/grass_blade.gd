extends Sprite2D
class_name Grass


@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var animation_duration: float = 0.3


func _on_body_entered(body: Node2D) -> void:
	animation_player.play("bend", -1, 1.0 / animation_duration, false)

func _on_body_exited(body: Node2D) -> void:
	animation_player.play("bend", -1, -1.0 / animation_duration, true)
