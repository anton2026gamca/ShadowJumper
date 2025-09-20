extends CharacterBody2D
class_name Bullet


@export var die_reason: String = "You were hit by a bullet"

@export var initial_speed: float = 400.0
@export var lifetime: float = -1

var indicator: NodeIndicator

signal finished


func _ready() -> void:
	indicator = Helpers.levels_ui.create_node_indicator(self)
	if lifetime == 0:
		_destroy()
		return
	if lifetime > 0:
		get_tree().create_timer(lifetime).timeout.connect(_destroy)
	velocity = Vector2.UP.rotated(rotation) * initial_speed

func _physics_process(delta: float) -> void:
	move_and_slide()

func _destroy(reason: String = "") -> void:
	if indicator: indicator.destroy()
	finished.emit()
	get_parent().remove_child.call_deferred(self)
	queue_free()

func _on_kill_area_body_entered(body: Node2D) -> void:
	var death_component: DeathComponent = Helpers.find_child_by_type(body, DeathComponent)
	if death_component:
		death_component.die(die_reason)
		if body is CharacterBody2D:
			body.velocity = self.velocity
		_destroy()

func _on_screen_entered() -> void:
	if indicator: indicator.visible = false

func _on_screen_exited() -> void:
	if indicator: indicator.visible = true
