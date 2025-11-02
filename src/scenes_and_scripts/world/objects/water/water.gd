extends Node2D
class_name Water

@export var die_reason: String = "DEATH_ELECTRIFIED_WATER"

@export var lightning_interval: float = 50

@onready var lightning_sprite: AnimatedSprite2D = $LightningSprite
@onready var lightning_sound_effect: AudioStreamPlayer2D = $LightningSoundEffect
@onready var point_light: PointLight2D = $PointLight2D
@onready var kill_area: Area2D = $PointLight2D/KillArea
@onready var splash_particles: CPUParticles2D = $SplashParticles
@onready var splash_sound_effect: AudioStreamPlayer2D = $SplashSoundEffect

static var bodies_in_water_data: Dictionary[Water, Array] = {}

func _ready() -> void:
	get_tree().create_timer(randf_range(0, lightning_interval), false).timeout.connect(_emit_lightning)
	lightning_sprite.animation_finished.connect(func() -> void: point_light.visible = false)

func _emit_lightning() -> void:
	if not is_inside_tree():
		return
	lightning_sprite.speed_scale = randf_range(1.0, 2.0)
	lightning_sprite.play("default")
	point_light.visible = true
	lightning_sound_effect.pitch_scale = randf_range(0.75, 1.25)
	lightning_sound_effect.play()
	await get_tree().create_timer(0.2, false).timeout
	var bodies_in_water: Array[Node2D] = get_bodies_in_water()
	for body: Node2D in kill_area.get_overlapping_bodies():
		if not body in bodies_in_water:
			continue
		var death_component: DeathComponent = Helpers.find_child_by_type(body, DeathComponent)
		if death_component:
			death_component.die(die_reason, true)
	get_tree().create_timer(lightning_interval, false).timeout.connect(_emit_lightning)

func get_bodies_in_water() -> Array[Node2D]:
	var bodies: Array[Node2D] = []
	for arr: Array in bodies_in_water_data.values():
		for body: Variant in arr:
			if not body is Node2D or body in bodies:
				continue
			bodies.append(body)
	return bodies

func _on_in_water_area_body_entered(body: Node2D) -> void:
	if not body in get_bodies_in_water():
		splash_particles.global_position.x = body.global_position.x
		splash_particles.restart()
		splash_sound_effect.pitch_scale = randf_range(1.8, 2.2)
		splash_sound_effect.play()
	if not self in bodies_in_water_data:
		bodies_in_water_data[self] = []
	bodies_in_water_data[self].append(body)

func _on_in_water_area_body_exited(body: Node2D) -> void:
	if not self in bodies_in_water_data:
		return
	bodies_in_water_data[self].erase(body)
