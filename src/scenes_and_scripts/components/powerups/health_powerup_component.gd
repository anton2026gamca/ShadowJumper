extends PlayerPowerup
class_name HealthPowerup


func activate(player: Player) -> void:
	player.lives += 1
	player.took_damage.connect(destroy)


func destroy(reason: String) -> void:
	await get_tree().process_frame
	get_parent().remove_child(self)
	queue_free()
