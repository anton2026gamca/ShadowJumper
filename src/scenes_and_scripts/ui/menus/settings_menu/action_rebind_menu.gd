@tool
extends HBoxContainer
class_name ActionRebindMenu


@export var action: StringName
@export var display: String = ""

@export_tool_button("Update") var update_btn: Callable = update

@onready var label: Label = $Label
@onready var rebind_buttons: Array[Button] = [$PrimaryRebindButton, $SecondaryRebindButton]

var is_rebinding: bool = false
signal on_event(e: InputEvent)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	if not event.is_released(): return
	if is_rebinding:
		on_event.emit(event)
		get_viewport().set_input_as_handled()


func event_to_str(ev: InputEvent) -> String:
	if not ev:
		return tr("CONTROLS_NOT_BOUND")
	if ev is InputEventKey:
		return OS.get_keycode_string(ev.physical_keycode)
	elif ev is InputEventMouseButton:
		match ev.button_index:
			MOUSE_BUTTON_LEFT: return tr("CONTROLS_MOUSE_LEFT")
			MOUSE_BUTTON_RIGHT: return tr("CONTROLS_MOUSE_RIGHT")
			MOUSE_BUTTON_MIDDLE: return tr("CONTROLS_MOUSE_MIDDLE")
			MOUSE_BUTTON_WHEEL_UP: return tr("CONTROLS_MOUSE_WHEEL_UP")
			MOUSE_BUTTON_WHEEL_DOWN: return tr("CONTROLS_MOUSE_WHEEL_DOWN")
			_: return "Mouse Button " + str(ev.button_index)
	else:
		return ev.as_text().substr(0, ev.as_text().find(" ("))

func set_action_event(action_name: String, event: InputEvent, index: int) -> void:
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	while events.size() <= index:
		events.append(null)
	events[index] = event
	InputMap.action_erase_events(action_name)
	for e: InputEvent in events:
		if e != null:
			InputMap.action_add_event(action_name, e)

func get_action_event(action: String, event_index: int) -> InputEvent:
	if not InputMap.has_action(action): return null
	var events: Array[InputEvent] = InputMap.action_get_events(action)
	if len(events) > event_index:
		return events[event_index]
	return null

func update():
	label.text = display
	var events: Array[InputEvent] = InputMap.action_get_events(action)
	for i: int in len(rebind_buttons):
		var binding: String = ""
		if len(events) > i:
			binding = event_to_str(events[i])
		rebind_buttons[i].text = binding

func rebind_action(index: int):
	if not InputMap.has_action(action): return
	rebind_buttons[index].text = tr("CONTROLS_WAITING")
	rebind_buttons[index].disabled = true
	is_rebinding = true
	var event = await on_event
	is_rebinding = false
	if not (event is InputEventKey and event.keycode == KEY_ESCAPE):
		set_action_event(action, event, index)
	rebind_buttons[index].disabled = false
	update()

func rebind_primary() -> void:
	rebind_action(0)

func rebind_secondary() -> void:
	rebind_action(1)
