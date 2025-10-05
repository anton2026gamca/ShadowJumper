extends NPC
class_name PowerupNpc


@export var drop_powerup_answer: NPCDialogAnswer
@export var powerup: PackedScene
const POWERUP_OBJECT: PackedScene = preload("res://scenes_and_scripts/world/objects/powerup_object.tscn")


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


func _on_msg_answer_picked(index: int, msg: NPCDialogAnswerMessage) -> void:
	if msg.answers[index].text == drop_powerup_answer.text:
		print("A")
		if powerup:
			var obj: PowerupObject = POWERUP_OBJECT.instantiate()
			obj.global_position = Helpers.camera.follow.global_position
			obj.powerup = powerup
			get_parent().add_child(obj)
