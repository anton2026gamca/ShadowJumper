@tool
extends Menu
class_name ControlsMenu


func _ready() -> void:
	load_input_map()

func close(internal: bool = false) -> void:
	save_input_map()
	await super.close(internal)

func save_input_map(path: String = "user://controls.cfg") -> void:
	if Engine.is_editor_hint():
		return
	var cfg: ConfigFile = ConfigFile.new()
	for rebind_menu: ActionRebindMenu in find_children("", "ActionRebindMenu"):
		if not InputMap.has_action(rebind_menu.action):
			continue
		var events_str: Array[String] = []
		for event: InputEvent in InputMap.action_get_events(rebind_menu.action):
			events_str.append(var_to_str(event))
		cfg.set_value("controls", rebind_menu.action, events_str)
	cfg.save(path)

func load_input_map(path: String = "user://controls.cfg") -> void:
	if Engine.is_editor_hint():
		return
	var cfg: ConfigFile = ConfigFile.new()
	if cfg.load(path) != OK:
		return
	for action: StringName in InputMap.get_actions():
		var cfg_value: Variant = cfg.get_value("controls", action, false)
		if not cfg_value is Array[String]:
			continue
		InputMap.action_erase_events(action)
		for event_str: String in cfg_value:
			var event: InputEvent = str_to_var(event_str)
			if event != null:
				InputMap.action_add_event(action, event)
	for menu: ActionRebindMenu in find_children("", "ActionRebindMenu", true):
		menu.update()

func reset() -> void:
	InputMap.load_from_project_settings()

	for menu: ActionRebindMenu in find_children("", "ActionRebindMenu", true):
		menu.update()
