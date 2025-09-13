extends Node2D
class_name Finish


signal level_defeated


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	level_defeated.emit()
