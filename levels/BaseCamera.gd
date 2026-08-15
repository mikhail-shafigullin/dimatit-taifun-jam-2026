extends Camera2D

const SWAY_AMPLITUDE = 3.0
const SWAY_SPEED = 1.5

var swayTime: float = 0.0

func _process(delta: float) -> void:
	swayTime += delta
	offset = Vector2(
		sin(swayTime * SWAY_SPEED) * SWAY_AMPLITUDE,
		cos(swayTime * SWAY_SPEED * 0.7) * SWAY_AMPLITUDE * 0.5
	)
