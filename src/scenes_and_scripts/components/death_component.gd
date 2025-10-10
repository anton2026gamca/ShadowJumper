extends Node
class_name DeathComponent


signal die_signal(reason: String, instant_kill: bool)


func die(reason: String = "", instant_kill: bool = false) -> void:
	die_signal.emit(reason, instant_kill)
