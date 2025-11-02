extends Sprite2D
class_name Rock

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	cpu_particles_2d.amount = max(4, cpu_particles_2d.amount / 2)
	cpu_particles_2d.emitting = true

func destroy() -> void:
	self_modulate = Color.TRANSPARENT
	await get_tree().create_timer(cpu_particles_2d.lifetime * 2).timeout
	get_parent().remove_child(self)
	queue_free()
