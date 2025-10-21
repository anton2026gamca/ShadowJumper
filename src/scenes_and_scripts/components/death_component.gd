extends Node
class_name DeathComponent


signal die_signal(reason: String, instant_kill: bool)

const HIT_MATERIAL: ShaderMaterial = preload("res://scenes_and_scripts/hit.material")


func die(reason: String = "", instant_kill: bool = false) -> void:
	var mat_override: bool = false
	var parent_mat_before: bool = false
	if not get_parent().material:
		mat_override = true
		get_parent().material = HIT_MATERIAL
		parent_mat_before = get_parent().use_parent_material
		get_parent().use_parent_material = false
	die_signal.emit(reason, instant_kill)
	if not mat_override or not get_parent():
		return
	await get_tree().process_frame
	while get_tree().paused:
		await get_tree().process_frame
	get_parent().use_parent_material = parent_mat_before
	get_parent().material = null
