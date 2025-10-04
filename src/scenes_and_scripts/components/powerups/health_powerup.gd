extends Powerup
class_name HealthPowerup


func activate(player: Player) -> void:
	player.health_component.lives += 1
	player.took_damage.connect(destroy)
