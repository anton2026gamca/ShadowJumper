extends Node
class_name Powerup


@export var player_texture_when_active: Texture2D
@export var pickup_message: String


func activate(player: Player) -> void:
	pass

func destroy(reason: String) -> void:
	await get_tree().process_frame
	get_parent().remove_child(self)
	queue_free()
