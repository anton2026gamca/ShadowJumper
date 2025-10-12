extends Sprite2D
class_name Grass


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Node/Area2D

@export var animation_duration: float = 0.3


func _process(delta: float) -> void:
	area_2d.global_position = global_position


func _on_body_entered(body: Node2D) -> void:
	animation_player.play("bend", -1, 1.0 / animation_duration, false)

func _on_body_exited(body: Node2D) -> void:
	animation_player.play("bend", -1, -1.0 / animation_duration, true)
