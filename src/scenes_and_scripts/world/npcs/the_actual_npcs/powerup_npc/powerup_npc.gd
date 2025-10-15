extends NPC
class_name PowerupNpc


@export var powerup_issued_message: NPCDialogMessage
@export var powerup_not_issued_message: NPCDialogMessage
@export var drop_powerup_answer: NPCDialogAnswer
@export var ask_message: NPCDialogAnswerMessage
@export var powerup: PackedScene
@export var powerup_price: int


func _ready() -> void:
	if not drop_powerup_answer:
		return
	for msg: NPCDialogMessage in dialog.messages:
		if not msg is NPCDialogAnswerMessage:
			continue
		for answer: NPCDialogAnswer in msg.answers:
			if not answer.text == drop_powerup_answer.text:
				continue
			msg.answer_picked.connect(_on_msg_answer_picked.bind(msg))
			break
	ask_message.message = ask_message.message.replace("{powerup_price}", str(powerup_price))


func _on_msg_answer_picked(answer: NPCDialogAnswer, msg: NPCDialogAnswerMessage) -> void:
	if answer.text == drop_powerup_answer.text:
		if powerup and Progress.total_collected_energy >= powerup_price:
			Progress.collect_energy(-powerup_price)
			Helpers.spawn_powerup(get_parent(), powerup, Helpers.player.global_position)
			drop_powerup_answer.next_messages = [powerup_issued_message.duplicate()]
		else:
			drop_powerup_answer.next_messages = [powerup_not_issued_message.duplicate()]
