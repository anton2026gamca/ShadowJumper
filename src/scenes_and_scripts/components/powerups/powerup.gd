extends Node
class_name Powerup


@export var pickup_message: String


func activate(player: Player) -> void:
	pass

func destroy(reason: String) -> void:
	await get_tree().process_frame
	get_parent().remove_child(self)
	queue_free()
