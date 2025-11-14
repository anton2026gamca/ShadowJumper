extends Node


var udp_socket: PacketPeerUDP = PacketPeerUDP.new()
const LED_PORT: int = 9999
const LED_HOST: String = "127.0.0.1"


func _ready() -> void:
	udp_socket.set_dest_address(LED_HOST, LED_PORT)
	trigger_animation("off", true)

func trigger_animation(animation_name: String, loop: bool = false, params: Dictionary = {}, speed: float = 1.0) -> void:
	var command: Dictionary = {
		"animation": animation_name,
		"loop": loop,
		"speed": speed,
		"params": params
	}
	var json_string: String = JSON.stringify(command)
	udp_socket.put_packet(json_string.to_utf8_buffer())

#func _on_player_hit():
	#trigger_animation("flash", false, {"color": [255, 0, 0], "duration": 5})
#
#func _on_level_complete():
	#trigger_animation("rainbow", true, {"speed": 0.15})
#
#func _on_powerup_collected():
	#trigger_animation("pulse", false, {"color": [0, 255, 255], "speed": 0.1})
