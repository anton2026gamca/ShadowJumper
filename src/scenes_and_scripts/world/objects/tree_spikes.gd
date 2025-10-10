extends AnimatedSprite2D
class_name TreeSpikes


@export var die_reason: String = "You stepped on really sharp spikes!"
@export var cooldown: float = 2.0


var is_hidden: bool = false

func _ready() -> void:
	play("hide-show")


func _on_body_entered(body: Node2D) -> void:
	if is_hidden: return
	var death_component: DeathComponent = Helpers.find_child_by_type(body, DeathComponent)
	if death_component:
		death_component.die(die_reason)
		_hide()


func _hide() -> void:
	play_backwards("hide-show")
	is_hidden = true
	await get_tree().create_timer(cooldown, false).timeout
	play("hide-show")
	await animation_finished
	is_hidden = false
