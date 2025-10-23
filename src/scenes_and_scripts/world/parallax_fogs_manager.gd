@tool
extends Node
class_name ParallaxFogsManager


@export_tool_button("Make Unique") var make_unique_btn: Callable = make_unique
@export_tool_button("Update") var update_btn: Callable = update
@export var fog_layers: Array[CanvasItem]
@export_range(0, 2, 0.01) var fog_intensity: float = 1.0:
	set(value):
		fog_intensity = value
		update()
	get: return fog_intensity
@export_range(0, 2, 0.01) var scroll_scale: float = 1.0


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func update() -> void:
	for fog: CanvasItem in fog_layers:
		if not fog.material is ShaderMaterial:
			continue
		fog.material.set_shader_parameter("fog_intensity", fog_intensity)
		fog.material.set_shader_parameter("scroll_scale", scroll_scale)

func make_unique() -> void:
	for fog: CanvasItem in fog_layers:
		if not fog.material:
			continue
		fog.material = fog.material.duplicate()
	print("ADADSSA")
