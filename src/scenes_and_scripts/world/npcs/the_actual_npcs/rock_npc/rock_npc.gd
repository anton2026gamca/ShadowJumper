extends NPC
class_name RockNpc


@export var rocks_amount: float
@export var text_color: Color = Color.WHITE
@export var give_rocks_after_message: NPCDialogMessage


func _ready() -> void:
	if give_rocks_after_message:
		give_rocks_after_message.message_finished.connect(_on_message_finished)

func _process(delta: float) -> void:
	pass

func _on_message_finished() -> void:
	var text: FloatingText = Helpers.create_floating_text(self, ("+" if rocks_amount >= 0 else "") + str(int(rocks_amount)) + " R", Vector2(0, -24), text_color, -10)
	text.process_mode = Node.PROCESS_MODE_ALWAYS
	Progress.collect_rocks(rocks_amount)
