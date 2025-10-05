extends Node2D
class_name EnergyCollectorComponent


func collect(amount: int) -> void:
	if amount == 0: return
	var color: Color = Color.WHITE
	if amount >= 250: color = Color.PURPLE
	elif amount >= 100: color = Color.RED
	elif amount >= 50: color = Color.ORANGE_RED
	elif amount >= 35: color = Color.ORANGE
	elif amount >= 25: color = Color.YELLOW
	Helpers.create_floating_text(get_parent().get_parent(), "+" + str(amount) + " E", position + get_parent().position + Vector2(randf_range(-8, 8), 0), color, -10)
	Settings.collected_energy += amount
