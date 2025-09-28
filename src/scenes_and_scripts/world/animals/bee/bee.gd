extends Animal
class_name Bee


@export var fly_speed: float = 250.0
@export var attack_min_height_diff: float = 100.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var death_audio: AudioStreamPlayer2D = $DeathAudio

@export var lives: int = 2

var indicator: NodeIndicator


func _ready() -> void:
	super._ready()
	indicator = Helpers.levels_ui.create_node_indicator(self)
	indicator.color = Color.BLUE_VIOLET

func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_death_component_die(reason: String) -> void:
	lives -= 1
	if lives > 0:
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
