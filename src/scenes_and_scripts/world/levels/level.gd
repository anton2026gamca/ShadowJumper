extends Node2D
class_name Level


@export var player: Player
@export var camera: Camera2D

signal player_died(reason: String)
signal level_defeated


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_world_bottom_limit_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die("You fell out of the world!")

func _on_player_died(reason: String) -> void:
	player_died.emit(reason)


func _on_finish_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	print(body)
	level_defeated.emit()
