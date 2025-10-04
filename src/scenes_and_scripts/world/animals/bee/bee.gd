extends Animal
class_name Bee


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio
var indicator: NodeIndicator
var enemy: Node2D

@onready var health_component: HealthComponent = $HealthComponent
@export var fly_speed: float = 250.0

@export var ultimate_attack_area: Area2D
var can_use_ultimate_attack: bool = true


func _ready() -> void:
	super._ready()
	enemy = Helpers.get_nearest_node_in_group(global_position, "Player")
	indicator = Helpers.levels_ui.create_node_indicator(self)
	indicator.color = Color.BLUE_VIOLET

func _physics_process(delta: float) -> void:
	if not enemy: enemy = Helpers.get_nearest_node_in_group(global_position, "Player")
	move_and_slide()


func _on_death_component_die(reason: String) -> void:
	health_component.lives -= 1
	if health_component.lives > 0:
		death_audio.play()
		state_machine.enabled = false
		await get_tree().create_timer(3).timeout
		state_machine.enabled = true
	else:
		state_machine.enabled = false
		sprite.play("die")
		collision_layer = 0
		death_audio.play()
		await sprite.animation_finished
		indicator.destroy()
		get_parent().remove_child(self)
		queue_free()
