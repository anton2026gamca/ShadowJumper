extends Menu
class_name ControlsMenu


func _ready() -> void:
	load_input_map()

func close(internal: bool = false) -> void:
	save_input_map()
	await super.close(internal)

func save_input_map(path: String = "user://controls.cfg") -> void:
	print("Saving")
	var cfg: ConfigFile = ConfigFile.new()
	for action: StringName in InputMap.get_actions():
		var events_str: Array[String] = []
		for event: InputEvent in InputMap.action_get_events(action):
			events_str.append(var_to_str(event))
		cfg.set_value("controls", action, events_str)
	cfg.save(path)

func load_input_map(path: String = "user://controls.cfg") -> void:
	print("Loading")
	var cfg: ConfigFile = ConfigFile.new()
	if cfg.load(path) != OK:
		return
	for action: StringName in InputMap.get_actions():
		InputMap.action_erase_events(action)
		for event_str: String in cfg.get_value("controls", action, []):
			var event: InputEvent = str_to_var(event_str)
			if event != null:
				InputMap.action_add_event(action, event)
	for menu: ActionRebindMenu in find_children("", "ActionRebindMenu", true):
		menu.update()
