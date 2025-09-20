extends Node
class_name DeathComponent


signal die_signal(reason: String)


func die(reason: String = "") -> void:
	die_signal.emit(reason)
