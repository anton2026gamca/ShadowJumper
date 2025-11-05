extends Node2D
class_name EnergyCollectorComponent


@export var energy_amount_for_action: Dictionary[String, EnergyCollectorAmount] = {}
var action_times_collected: Dictionary[EnergyCollectorAmount, int] = {}


func _ready() -> void:
	reset()

func collect(action: String) -> void:
	if not action in energy_amount_for_action: return
	var amount: EnergyCollectorAmount = energy_amount_for_action[action]
	if action_times_collected[amount] >= amount.max_collects and amount.max_collects >= 0: return
	action_times_collected[amount] += 1
	if amount.energy_value_on_collect == 0: return
	var color: Color = Color.WHITE
	if amount.energy_value_on_collect >= 250: color = Color.PURPLE
	elif amount.energy_value_on_collect >= 100: color = Color.RED
	elif amount.energy_value_on_collect >= 50: color = Color.ORANGE_RED
	elif amount.energy_value_on_collect >= 35: color = Color.ORANGE
	elif amount.energy_value_on_collect >= 25: color = Color.YELLOW
	Helpers.create_floating_text(LevelLoader.level_ui_nodes, "+" + str(amount.energy_value_on_collect) + " E", position + get_parent().position + Vector2(randf_range(-8, 8), 0), color, -10)
	Progress.collect_energy(amount.energy_value_on_collect)

func reset() -> void:
	action_times_collected = {}
	for amount: EnergyCollectorAmount in energy_amount_for_action.values():
		action_times_collected[amount] = 0
