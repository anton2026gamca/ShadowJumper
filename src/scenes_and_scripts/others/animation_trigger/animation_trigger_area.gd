@tool
extends CollisionShape2D
class_name AnimationTriggerArea


@export var animation: StringName


func _process(delta: float) -> void:
	if shape and not shape is RectangleShape2D:
		shape = null
		printerr("Parameter \"shape\" has to be RectangleShape2D")
