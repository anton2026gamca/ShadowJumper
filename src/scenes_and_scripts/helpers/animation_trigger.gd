@tool
extends Node2D
class_name AnimationTrigger


@export var enabled: bool = true
@export var animation_player: AnimationPlayer
@export var source: Node2D

var current_transition: int = 0

var time: float = 0


func _ready() -> void:
	if not Engine.is_editor_hint():
		enabled = true
		current_transition = 0
		animation_player.play("RESET")

func _process(delta: float) -> void:
	if source:
		update()

func update() -> void:
	if not enabled:
		return
	var areas: Array[Node] = find_children("", "AnimationTriggerArea")
	for i: int in len(areas):
		if not areas[i].shape is RectangleShape2D:
			continue
		var left: float = areas[i].position.x - areas[i].shape.size.x / 2.0
		var right: float = areas[i].position.x + areas[i].shape.size.x / 2.0
		if right < source.position.x and not i == len(areas) - 1:
			continue
		current_transition = i + 1
		var value: float = clamp((source.position.x - left) / areas[i].shape.size.x, 0.0, 1.0)
		var direction: float = Vector2(value - animation_player.current_animation_position, 0.0).normalized().x
		if value == 0: value = randf_range(0, 0.01) # Randomize the values at the ends so that the animation player updates
		if value == 1: value = randf_range(0.99, 1)
		animation_player.play_section(areas[i].animation, value, -1, -1, direction)
		break
