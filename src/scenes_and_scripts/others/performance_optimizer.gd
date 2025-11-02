extends Node
class_name PerformanceOptimizer


static func optimize_particles_in_tree(root: Node, reduction_factor: float = 0.5) -> void:
	for child in root.get_children():
		if child is CPUParticles2D:
			var particles := child as CPUParticles2D
			particles.amount = max(min(4, particles.amount), int(particles.amount * reduction_factor))
			particles.fixed_fps = 30
		if child.get_child_count() > 0:
			optimize_particles_in_tree(child, reduction_factor)

static func optimize_lights_in_tree(root: Node) -> void:
	for child: Node in root.get_children():
		if child is PointLight2D:
			var light := child as PointLight2D
			light.shadow_enabled = false
		if child.get_child_count() > 0:
			optimize_lights_in_tree(child)

static func apply_all_optimizations(root: Node) -> void:
	optimize_particles_in_tree(root, 0.5)
	optimize_lights_in_tree(root)
