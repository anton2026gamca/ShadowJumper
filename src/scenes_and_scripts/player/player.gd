@tool
extends CharacterBody2D
class_name Player


var enable_in_editor: bool = false

var light_sources: Array[Node2D]
var colliding_mushroom: Mushroom
var in_mushroom_radius_time: float = 0

signal died(reason: String)


func _ready() -> void:
	enable_in_editor = false
	if Engine.is_editor_hint():
		return

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint() and not enable_in_editor:
		return
	if (colliding_mushroom and not colliding_mushroom.is_on) or (not colliding_mushroom and len(light_sources) > 0):
		_update_colliding_mushroom()
	if colliding_mushroom:
		if colliding_mushroom.boom_state == 0:
			colliding_mushroom.start_making_boom()
		if colliding_mushroom.boom_state == 1:
			if await colliding_mushroom.update_boom(in_mushroom_radius_time):
				die("A mushroom electrified you!")
				return
		if in_mushroom_radius_time <= 0:
			colliding_mushroom.stop_making_boom()
			in_mushroom_radius_time = 0
	move_and_slide()


func die(reason: String) -> void:
	$DeathAudio.pitch_scale = randf() * 0.2 + 0.9
	$DeathAudio.play()
	died.emit(reason)

func _on_light_area_body_entered(body: Node2D) -> void:
	light_sources.append(body)
	_update_colliding_mushroom()

func _on_light_area_body_exited(body: Node2D) -> void:
	light_sources.remove_at(light_sources.find(body))
	_update_colliding_mushroom()

func _update_colliding_mushroom() -> void:
	var before: Mushroom = colliding_mushroom
	colliding_mushroom = null
	for light_source: Node2D in light_sources:
		if light_source.get_parent() is Mushroom and light_source.get_parent().is_on:
			colliding_mushroom = light_source.get_parent()
			break
	if before is Mushroom and colliding_mushroom != before:
		before.stop_making_boom()
		in_mushroom_radius_time = 0
