extends Level
class_name Level1


@onready var tutorial_powerup_nodes: Array[Node] = [$Level/Tutorial/PowerupHint, $Level/Tutorial/PowerupObject]


func _ready() -> void:
	super._ready()
	if Helpers.dictionary_get_path(LevelLoader.current_level_data, ["tutorial", "powerup_picked_up"], false):
		for node: Node in tutorial_powerup_nodes:
			node.get_parent().remove_child(node)
			node.queue_free()


func _on_powerup_object_picked_up() -> void:
	Helpers.dictionary_set_path(LevelLoader.current_level_data, ["tutorial", "powerup_picked_up"], true)
	await get_tree().process_frame
	for node: Node in tutorial_powerup_nodes:
		node.get_parent().remove_child(node)
		node.queue_free()
