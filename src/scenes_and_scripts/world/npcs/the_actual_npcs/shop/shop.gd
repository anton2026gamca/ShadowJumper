extends NPC
class_name Shop


@export var items_on_sale: Array[ShopItem]

@export var bought_item_messages: Array[NPCDialogMessage]
@export var out_of_stock_messages: Array[NPCDialogMessage]
@export var not_enough_energy_messages: Array[NPCDialogMessage]

@export var pick_item_message: NPCDialogAnswerMessage


const ITEM_NAME: String = "{item_name}"
const ITEM_PRICE: String = "{item_price}"
const ITEM_STOCK: String = "{item_stock}"

const ITEM_NAME_COLOR: String = "{item_name_color}"
const ITEM_STOCK_COLOR: String = "{item_stock_color}"
const PRICE_COLOR: String = "gold"
const DELIMITER_COLOR: String = "gray"

const IN_STOCK_COLOR: String = "lime"
const OUT_OF_STOCK_COLOR: String = "red"
const INF_STOCK_COLOR: String = "gray"


func parse_items() -> void:
	pick_item_message.answers = []
	if not pick_item_message.answer_picked.is_connected(buy_item):
		pick_item_message.answer_picked.connect(buy_item)
	for item: ShopItem in items_on_sale:
		var message: String = ""
		message += "[color=" + PRICE_COLOR + "]"
		for i: int in range(4 - len(parse_message(ITEM_PRICE, item))):
			message += " "
		message += ITEM_PRICE + " E[/color]"
		message += "[color=" + DELIMITER_COLOR + "] | [/color]"
		message += "[color=" + ITEM_STOCK_COLOR + "]"
		for i: int in range(3 - len(parse_message(ITEM_STOCK, item))):
			message += " "
		message += ITEM_STOCK + "[/color]"
		message += "[color=" + DELIMITER_COLOR + "] | [/color]"
		message += "[color=" + ITEM_NAME_COLOR + "]" + ITEM_NAME + "[/color]"
		var answer: NPCDialogAnswer = NPCDialogAnswer.new()
		answer.text = parse_message(message, item)
		answer.npc_sprite_override = item.sprite
		pick_item_message.answers.append(answer)
	var nothing_answer: NPCDialogAnswer = NPCDialogAnswer.new()
	nothing_answer.text = "[color=gray]  Nothing, thanks![/color]"
	pick_item_message.answers.append(nothing_answer)

func buy_item(answer: NPCDialogAnswer) -> void:
	var index: int = pick_item_message.answers.find(answer)
	if index < 0 or index >= len(items_on_sale): return
	var item: ShopItem = items_on_sale[index]
	if item.stock == 0:
		answer.next_messages = out_of_stock_messages.duplicate()
	elif Settings.total_collected_energy < item.price:
		answer.next_messages = not_enough_energy_messages.duplicate()
	else:
		answer.next_messages = bought_item_messages.duplicate()
		item.stock -= 1
		Settings.collect(-item.price)
		if item is ShopPowerupItem:
			Helpers.spawn_powerup(self, item.powerup, Vector2.ZERO)
	
	for i: int in len(answer.next_messages):
		var msg: NPCDialogMessage = answer.next_messages[i].duplicate()
		msg.message = parse_message(msg.message, item)
		answer.next_messages[i] = msg

func parse_message(msg: String, item: ShopItem) -> String:
	return msg\
		.replace(ITEM_NAME, item.name)\
		.replace(ITEM_PRICE, str(item.price))\
		.replace(ITEM_STOCK, str(item.stock) if item.stock >= 0 else "INF")\
		.replace(ITEM_NAME_COLOR, "#" + item.color.to_html(false))\
		.replace("{price_color}", PRICE_COLOR)\
		.replace(ITEM_STOCK_COLOR, IN_STOCK_COLOR if item.stock > 0 else (OUT_OF_STOCK_COLOR if item.stock == 0 else INF_STOCK_COLOR))\
		.replace("{player_energy}", str(int(Settings.total_collected_energy)))

func _on_body_entered(body: Node2D) -> void:
	parse_items()
	super._on_body_entered(body)
