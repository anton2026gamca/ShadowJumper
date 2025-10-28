@tool
extends HBoxContainer
class_name HealthComponent


var _life_nodes: Array[TextureRect] = []

@export_tool_button("Update") var update_btn: Callable = update

@export var lives: int = 0:
	set(value):
		lives = value
		update()
	get: return lives
@export var life_texture: Texture2D
@export var display_if_one_life: bool = true


func _ready() -> void:
	var children: Array[Node] = get_children()
	_life_nodes = []
	for child: Node in children:
		if child is TextureRect:
			_life_nodes.append(child)
	update()


func update() -> void:
	for node: TextureRect in _life_nodes:
		node.visible = false
		node.texture = life_texture
	for i: int in range(lives) if lives != 1 or display_if_one_life else 0:
		if i < len(_life_nodes):
			_life_nodes[i].visible = true
		else:
			var new: TextureRect = TextureRect.new()
			new.texture = life_texture
			new.use_parent_material = true
			add_child(new)
			_life_nodes.append(new)
	for i: int in range(len(_life_nodes) - 1, -1, -1):
		if not _life_nodes[i].visible:
			remove_child(_life_nodes[i])
			_life_nodes[i].queue_free()
			_life_nodes.remove_at(i)
