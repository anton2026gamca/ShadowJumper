extends NPC
class_name Shop


@export var items_on_sale: Array[ShopItem]
@export var pick_item_message: NPCDialogAnswerMessage


func _ready() -> void:
	parse_items()

func _process(delta: float) -> void:
	pass


func parse_items() -> void:
	pick_item_message.answers = []
	for item: ShopItem in items_on_sale:
		var message: String = ""
		message += "[color=gold]"
		for i: int in range(4 - len(str(item.price))):
			message += " "
		message += str(item.price) + " E[/color]"
		message += "[color=grey] | [/color]"
		message += "[color=" + ("gray" if item.stock > 0 else "red") + "]"
		for i: int in range(2 - len(str(item.stock))):
			message += " "
		message += str(item.stock) + "[/color]"
		message += "[color=grey] | [/color]"
		message += item.name
		var answer: NPCDialogAnswer = NPCDialogAnswer.new()
		answer.text = message
		pick_item_message.answers.append(answer)
