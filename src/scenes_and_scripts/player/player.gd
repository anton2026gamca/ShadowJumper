@tool
extends CharacterBody2D
class_name Player


@onready var sprite: AnimatedSprite2D = $Sprite

var enable_in_editor: bool = false
var controller: PlayerController

@onready var health_component: HealthComponent = $HealthComponent
signal died(reason: String)
signal took_damage(reason: String)

@onready var death_particles: CPUParticles2D = $DeathParticles
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio
@onready var climb_ladder_area: Area2D = $ClimbLadderArea

var has_immunity: bool = false


func _ready() -> void:
	enable_in_editor = false
	if Engine.is_editor_hint(): return
	Helpers.player = self

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	
	var anim: String = ""
	#if abs(velocity.y) > abs(velocity.x):
		#if velocity.y < 0:
			#anim = "up"
		#elif velocity.y > 0:
			#anim = "down"
	#else:
	if velocity.x < 0:
		anim = "left"
	elif velocity.x > 0:
		anim = "right"
	
	if anim != "" and sprite.frame == 0:
		sprite.play(anim)
	elif anim == "" and sprite.frame != 0:
		sprite.play_backwards(sprite.animation)
	
	move_and_slide()

func _on_death_component_die(reason: String, instant_kill: bool = false) -> void:
	if has_immunity and not instant_kill:
		return
	health_component.lives -= 1
	if instant_kill:
		health_component.lives = 0
	took_damage.emit(reason)
	death_audio.pitch_scale = randf() * 0.2 + 0.9
	death_audio.play()
	if health_component.lives == 0:
		died.emit(reason)
		sprite.visible = false
		Helpers.camera.enter_death_mode(velocity.x)
		emit_death_particles()
	else:
		has_immunity = true
		sprite.modulate.a = 0.5
		await get_tree().create_timer(controller.immunity_time, false).timeout
		sprite.modulate.a = 1
		has_immunity = false

func pickup_powerup(powerup_scene: PackedScene) -> Powerup:
	var node: Node = powerup_scene.instantiate()
	if not node is Powerup:
		node.queue_free()
		return null
	node.activate(self)
	add_child(node)
	return node

func emit_death_particles() -> void:
	death_particles.direction = velocity.normalized()
	var initial_velocity: float = Vector2.ZERO.distance_to(velocity)
	death_particles.initial_velocity_min = initial_velocity
	death_particles.initial_velocity_max = initial_velocity
	death_particles.emitting = true
