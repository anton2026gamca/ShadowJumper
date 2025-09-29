extends State
class_name BeeUltimateAttack


@export var target: Bee

@export var ult_attack_buttet: PackedScene
@export var bullet_spawner: Node2D
@export var ult_attack_audio: AudioStreamPlayer2D
@export var ult_attack_shoot_audio: AudioStreamPlayer2D

var exit: bool = false


func process(_delta: float) -> Variant:
	return null


func on_enter() -> void:
	ultimate_attack()


func ultimate_attack() -> void:
	target.can_use_ultimate_attack = false
	target.velocity = Vector2.ZERO
	ult_attack_audio.play()
	await get_tree().create_timer(2).timeout
	var bullet = ult_attack_buttet.instantiate()
	bullet.rotation_degrees = 180
	bullet.global_position = bullet_spawner.global_position
	bullet.target = target.enemy
	target.get_parent().add_child(bullet)
	ult_attack_shoot_audio.play()
	exit = true
