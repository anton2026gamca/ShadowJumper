extends Sprite2D
class_name TreeSpikes


@export var die_reason: String = "You stepped on really sharp spikes!"


func _on_body_entered(body: Node2D) -> void:
	var death_component: DeathComponent = Helpers.find_child_by_type(body, DeathComponent)
	if death_component:
		death_component.die(die_reason)
