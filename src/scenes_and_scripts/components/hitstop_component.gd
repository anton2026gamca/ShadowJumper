extends Node
class_name HitstopComponent


func hitstop(time: float) -> void:
	await get_tree().process_frame
	get_tree().paused = true
	await get_tree().create_timer(time).timeout
	get_tree().paused = false
