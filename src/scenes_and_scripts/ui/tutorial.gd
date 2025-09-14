extends Control
class_name Tutorial


@export var steps: Array[Control]
var current: int = 0

func _ready() -> void:
	for step: Control in steps:
		step.visible = false
	if len(steps) > 0:
		steps[current].visible = true
		get_tree().paused = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		next_step()

func next_step() -> void:
	steps[current].visible = false
	current += 1
	if current >= len(steps):
		get_tree().paused = false
		get_parent().remove_child(self)
		self.queue_free()
		return
	steps[current].visible = true
