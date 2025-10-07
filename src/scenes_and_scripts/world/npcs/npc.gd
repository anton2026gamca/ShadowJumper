extends Sprite2D
class_name NPC


@export var dialog: NPCDialog
@export var cooldown: float = 5.0
@export var one_time: bool = false

@export var unique_id: int

var can_play: bool = true


func _on_body_entered(body: Node2D) -> void:
	if not body is Player or not can_play: return
	if one_time:
		if Settings.disable_npcs.has(unique_id): return
		Settings.disable_npcs.append(unique_id)
	Helpers.levels_ui.dialog_ui.play_dialog(dialog)
	can_play = false
	if cooldown >= 0:
		await get_tree().create_timer(cooldown, false).timeout
		can_play = true
