extends NPC
class_name Shop


@export var items_on_sale: Array[ShopItem]

@export var bought_item_messages: Array[NPCDialogMessage]
@export var out_of_stock_messages: Array[NPCDialogMessage]
@export var not_enough_energy_messages: Array[NPCDialogMessage]

@export var pick_item_message: NPCDialogAnswerMessage

@export var buy_nothing_sprite: Texture2D


const IN_STOCK_COLOR: String = "lime"
const OUT_OF_STOCK_COLOR: String = "red"
const INF_STOCK_COLOR: String = "gray"

const TOKEN: Dictionary[String, String] = {
	ITEM_NAME = "{item_name}",
	ITEM_PRICE = "{item_price}",
	ITEM_STOCK = "{item_stock}",
	ITEM_NAME_COLOR = "{item_name_color}",
	ITEM_STOCK_COLOR = "{item_stock_color}",
	DELIMITER_COLOR = "{delimiter_color}",
	PRICE_COLOR = "{price_color}",
	PLAYER_ENERGY = "{player_energy}",
}
var TOKEN_TO_VALUE: Dictionary[String, Callable] = {
	TOKEN.ITEM_NAME: func(item: ShopItem) -> String: return tr("SHOP_ITEM_" + item.name.to_upper().replace(" ", "_")),
	TOKEN.ITEM_PRICE: func(item: ShopItem) -> String: return str(item.price),
	TOKEN.ITEM_STOCK: func(item: ShopItem) -> String: return str(int(Helpers.dictionary_get_path(Progress.global_data, ["shop", item.name, "stock"], item.stock))) if item.stock >= 0 else "INF",
	TOKEN.ITEM_NAME_COLOR: func(item: ShopItem) -> String: return "#" + item.color.to_html(false),
	TOKEN.ITEM_STOCK_COLOR: func(item: ShopItem) -> String: return IN_STOCK_COLOR if item.stock > 0 else (OUT_OF_STOCK_COLOR if item.stock == 0 else INF_STOCK_COLOR),
	TOKEN.DELIMITER_COLOR: func(item: ShopItem) -> String: return "gray",
	TOKEN.PRICE_COLOR: func(item: ShopItem) -> String: return "gold",
	TOKEN.PLAYER_ENERGY: func(item: ShopItem) -> String: return str(int(Progress.total_collected_energy)),
}


func parse_items() -> void:
	pick_item_message.answers = []
	if not pick_item_message.answer_picked.is_connected(buy_item):
		pick_item_message.answer_picked.connect(buy_item)
	for item: ShopItem in items_on_sale:
		var message: String = ""
		message += "[color=" + TOKEN.PRICE_COLOR + "]"
		for i: int in range(4 - len(parse_message(TOKEN.ITEM_PRICE, item))):
			message += " "
		message += TOKEN.ITEM_PRICE + tr("STATS_ENERGY_SUFFIX") + "[/color]"
		message += "[color=" + TOKEN.DELIMITER_COLOR + "] | [/color]"
		message += "[color=" + TOKEN.ITEM_STOCK_COLOR + "]"
		for i: int in range(3 - len(parse_message(TOKEN.ITEM_STOCK, item))):
			message += " "
		message += TOKEN.ITEM_STOCK + "[/color]"
		message += "[color=" + TOKEN.DELIMITER_COLOR + "] | [/color]"
		message += "[color=" + TOKEN.ITEM_NAME_COLOR + "]" + TOKEN.ITEM_NAME + "[/color]"
		var answer: NPCDialogAnswer = NPCDialogAnswer.new()
		answer.text = parse_message(message, item)
		answer.npc_sprite_override = item.sprite
		pick_item_message.answers.append(answer)
	var nothing_answer: NPCDialogAnswer = NPCDialogAnswer.new()
	nothing_answer.text = "[color=gray]" + tr("SHOP_NOTHING_THANKS") + "[/color]"
	nothing_answer.npc_sprite_override = buy_nothing_sprite
	pick_item_message.answers.append(nothing_answer)

func buy_item(answer: NPCDialogAnswer) -> void:
	var index: int = pick_item_message.answers.find(answer)
	if index < 0 or index >= len(items_on_sale): return
	var item: ShopItem = items_on_sale[index]
	var stock: int = Helpers.dictionary_get_path(Progress.global_data, ["shop", item.name, "stock"], item.stock)
	if stock == 0:
		var msgs: Array[NPCDialogMessage] = out_of_stock_messages.duplicate()
		for i: int in len(msgs):
			msgs[i] = msgs[i].duplicate()
			msgs[i].message = parse_message(tr(msgs[i].message), item)
		answer.next_messages = msgs
	elif Progress.total_collected_energy < item.price:
		var msgs: Array[NPCDialogMessage] = not_enough_energy_messages.duplicate()
		for i: int in len(msgs):
			msgs[i] = msgs[i].duplicate()
			msgs[i].message = parse_message(tr(msgs[i].message), item)
		answer.next_messages = msgs
	else:
		var msgs: Array[NPCDialogMessage] = bought_item_messages.duplicate()
		for i: int in len(msgs):
			msgs[i] = msgs[i].duplicate()
			msgs[i].message = parse_message(tr(msgs[i].message), item)
		answer.next_messages = msgs
		Helpers.dictionary_set_path(Progress.global_data, ["shop", item.name, "stock"], stock - 1 if stock >= 1 else stock)
		Progress.collect_energy(-item.price)
		if item is ShopPowerupItem:
			Helpers.spawn_powerup(self, item.powerup, Vector2.ZERO)
		elif item is ShopRocksItem:
			# It has to be $Area2D instead of self because of some weird thing with TileMapLayer
			var text: FloatingText = Helpers.create_floating_text(LevelLoader.level_ui_nodes, ("+" if item.rocks_amount >= 0 else "") + str(int(item.rocks_amount)) + tr("STATS_ROCKS_SUFFIX"), $Area2D.global_position + Vector2(0, -32), item.color, -10)
			text.process_mode = Node.PROCESS_MODE_ALWAYS
			Progress.collect_rocks(item.rocks_amount)
	
	for i: int in len(answer.next_messages):
		var msg: NPCDialogMessage = answer.next_messages[i].duplicate()
		msg.message = parse_message(msg.message, item)
		answer.next_messages[i] = msg

func parse_message(msg: String, item: ShopItem) -> String:
	for token: String in TOKEN.values():
		if not TOKEN_TO_VALUE.has(token):
			continue
		msg = msg.replace(token, TOKEN_TO_VALUE[token].call(item))
	return msg

func _on_body_entered(body: Node2D) -> void:
	parse_items()
	super._on_body_entered(body)
