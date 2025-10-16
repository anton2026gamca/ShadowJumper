@tool
extends Menu
class_name ControlsMenu


func _ready() -> void:
	super._ready()
	if not Engine.is_editor_hint():
		Settings.loaded.connect(load_input_map)


func close(internal: bool = false) -> void:
	if not Engine.is_editor_hint():
		save_input_map()
	await super.close(internal)

func save_input_map() -> void:
	for rebind_menu: ActionRebindMenu in find_children("", "ActionRebindMenu"):
		if not InputMap.has_action(rebind_menu.action):
			continue
		var events_str: Array[String] = []
		for event: InputEvent in InputMap.action_get_events(rebind_menu.action):
			events_str.append(var_to_str(event))
		Settings.set_value(Settings.Category.CONTROLS, [rebind_menu.action], events_str)
	Settings.save_to_file()

func load_input_map() -> void:
	for action: StringName in InputMap.get_actions():
		var events_str: Variant = Settings.get_value(Settings.Category.CONTROLS, [str(action)])
		if not events_str is Array:
			continue
		InputMap.action_erase_events(action)
		for event_str: Variant in events_str:
			if not event_str is String:
				continue
			var event: InputEvent = str_to_var(event_str)
			if event != null:
				InputMap.action_add_event(action, event)
	for menu: ActionRebindMenu in find_children("", "ActionRebindMenu"):
		menu.update()

func reset() -> void:
	InputMap.load_from_project_settings()
	for menu: ActionRebindMenu in find_children("", "ActionRebindMenu"):
		menu.update()
