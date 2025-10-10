@tool
extends CharacterBody2D
class_name Player


@onready var death_audio: AudioStreamPlayer2D = $DeathAudio
@onready var sprite: Sprite2D = $Sprite

var enable_in_editor: bool = false
var controller: PlayerController

@onready var health_component: HealthComponent = $HealthComponent
signal died(reason: String)
signal took_damage(reason: String)

var default_texture: Texture2D


func _ready() -> void:
	default_texture = sprite.texture
	enable_in_editor = false
	if Engine.is_editor_hint(): return
	Helpers.player = self

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	move_and_slide()

func _on_death_component_die(reason: String, instant_kill: bool = false) -> void:
	health_component.lives -= 1
	if instant_kill:
		health_component.lives = 0
	took_damage.emit(reason)
	death_audio.pitch_scale = randf() * 0.2 + 0.9
	death_audio.play()
	if health_component.lives == 0:
		died.emit(reason)

func pickup_powerup(powerup_scene: PackedScene) -> Powerup:
	var node: Node = powerup_scene.instantiate()
	if not node is Powerup:
		node.queue_free()
		return null
	node.activate(self)
	add_child(node)
	#if node.player_texture_when_active:
		#sprite.texture = node.player_texture_when_active
	return node
