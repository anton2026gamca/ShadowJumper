extends Bullet
class_name BeeUltimateAttackButtel


var target: Node2D
var time: float = 0

@export var homing_rate_curve: Curve

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var death_component: DeathComponent = $DeathComponent


func _ready() -> void:
	super._ready()
	time = 0
	cpu_particles_2d.emitting = true
	if death_component.die_signal.is_connected(_destroy):
		death_component.die_signal.disconnect(_destroy)

func _physics_process(delta: float) -> void:
	time += delta
	var homing_rate: float = homing_rate_curve.sample(time)
	var to_target: Vector2 = (target.global_position - global_position).normalized()
	var rotation_step: float = clamp(velocity.angle_to(to_target), -homing_rate * delta, homing_rate * delta)
	velocity = velocity.rotated(rotation_step)
	rotation = velocity.angle() + PI / 2
	cpu_particles_2d.angle_min = velocity.angle()
	cpu_particles_2d.angle_max = velocity.angle()
	move_and_slide()

func _on_kill_area_body_entered(body: Node2D) -> void:
	if body == target:
		super._on_kill_area_body_entered(body)
