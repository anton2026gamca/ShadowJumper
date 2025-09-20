extends CharacterBody2D
class_name Animal


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_death_component_die(reason: String) -> void:
	get_parent().remove_child.call_deferred(self)
	queue_free()
