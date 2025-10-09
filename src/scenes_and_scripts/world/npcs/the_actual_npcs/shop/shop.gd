extends NPC
class_name Shop


@export var items_on_sale: Array[ShopItem]

@export var bought_item_messages: Array[NPCDialogMessage]
@export var out_of_stock_messages: Array[NPCDialogMessage]
@export var not_enough_energy_messages: Array[NPCDialogMessage]

@export var pick_item_message: NPCDialogAnswerMessage


func parse_items() -> void:
	pick_item_message.answers = []
	if not pick_item_message.answer_picked.is_connected(buy_item):
		pick_item_message.answer_picked.connect(buy_item)
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

func buy_item(index: int) -> void:
	var dialog_answer: NPCDialogAnswer = pick_item_message.answers[index]
	var item: ShopItem = items_on_sale[index]
	if items_on_sale[index].stock <= 0:
		dialog_answer.next_messages = out_of_stock_messages.duplicate()
	elif Settings.total_collected_energy < item.price:
		dialog_answer.next_messages = not_enough_energy_messages.duplicate()
	else:
		dialog_answer.next_messages = bought_item_messages.duplicate()
		items_on_sale[index].stock -= 1
		Settings.collect(-item.price)
	for i: int in len(dialog_answer.next_messages):
		var msg: NPCDialogMessage = dialog_answer.next_messages[i].duplicate()
		msg.message = msg.message.replace("{item_name}", item.name)\
			.replace("{item_stock}", str(item.stock))\
			.replace("{item_price}", str(item.price))\
			.replace("{player_energy}", str(int(Settings.total_collected_energy)))
		dialog_answer.next_messages[i] = msg

func _on_body_entered(body: Node2D) -> void:
	parse_items()
	super._on_body_entered(body)
