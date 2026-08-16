class_name WalkAnimationComponent
extends Node

const MAX_TILT_DEGREES := 6.0
const STEP_FREQUENCY := 16.0
const MOVE_THRESHOLD := 5.0
const RETURN_SPEED := 720.0

@onready var _body: CharacterBody2D = get_parent() as CharacterBody2D
@onready var _sprite: Sprite2D = %Sprite2D

var _phase: float = 0.0
var _tiltDegrees: float = 0.0
var _basePosition: Vector2

func _ready() -> void:
	_basePosition = _sprite.position

func _process(delta: float) -> void:
	if _body == null or _sprite == null:
		return
	if _body.velocity.length() > MOVE_THRESHOLD:
		_phase += delta * STEP_FREQUENCY
		_tiltDegrees = sin(_phase) * MAX_TILT_DEGREES
	else:
		_phase = 0.0
		_tiltDegrees = move_toward(_tiltDegrees, 0.0, RETURN_SPEED * delta)
	_applyTilt(_tiltDegrees)

## Sprite2D rotates around its own origin (texture center), so we rotate around
## a pivot at the sprite's bottom edge instead and re-anchor its position each frame
## to keep that bottom edge fixed in place, imitating weight rocking on planted feet.
func _applyTilt(angleDegrees: float) -> void:
	var angleRad := deg_to_rad(angleDegrees)
	var pivot := _basePosition + Vector2(0.0, _spriteBottomOffset())
	_sprite.rotation = angleRad
	_sprite.position = pivot + (_basePosition - pivot).rotated(angleRad)

func _spriteBottomOffset() -> float:
	if _sprite.texture == null:
		return 0.0
	var halfHeight := _sprite.texture.get_height() * (0.5 if _sprite.centered else 1.0)
	return (halfHeight + _sprite.offset.y) * _sprite.scale.y
