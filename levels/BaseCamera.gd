extends Camera2D

const SWAY_AMPLITUDE = 3.0
const SWAY_SPEED = 1.5

@export var minZoom: float = 0.55
@export var maxZoom: float = 1.15
@export var framingPadding: Vector2 = Vector2(150.0, 150.0)
@export var positionSmoothing: float = 5.0
@export var zoomSmoothing: float = 3.5

var swayTime: float = 0.0

var _defaultPosition: Vector2
var _defaultZoom: Vector2
var _targetPosition: Vector2
var _targetZoom: Vector2
var _framingActive: bool = false

func _ready() -> void:
	_defaultPosition = position
	_defaultZoom = zoom
	_targetPosition = _defaultPosition
	_targetZoom = _defaultZoom
	EventBus.unit_choice_phase_started.connect(_onUnitChoicePhaseStarted)
	EventBus.battle_phase_started.connect(_onBattlePhaseStarted)

func _process(delta: float) -> void:
	swayTime += delta
	offset = Vector2(
		sin(swayTime * SWAY_SPEED) * SWAY_AMPLITUDE,
		cos(swayTime * SWAY_SPEED * 0.7) * SWAY_AMPLITUDE * 0.5
	)

	if _framingActive:
		_updateFramingTargets()

	var positionWeight := 1.0 - exp(-positionSmoothing * delta)
	var zoomWeight := 1.0 - exp(-zoomSmoothing * delta)
	position = position.lerp(_targetPosition, positionWeight)
	zoom = zoom.lerp(_targetZoom, zoomWeight)

func _gatherCombatantPositions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	for combatComponent in get_tree().get_nodes_in_group("units") + get_tree().get_nodes_in_group("enemies"):
		var body := combatComponent.get_parent() as Node2D
		if body != null:
			positions.append(body.global_position)
	return positions

func _computeBounds(positions: Array[Vector2]) -> Rect2:
	var bounds := Rect2(positions[0], Vector2.ZERO)
	for point in positions:
		bounds = bounds.expand(point)
	return bounds

func _updateFramingTargets() -> void:
	var positions := _gatherCombatantPositions()
	if positions.is_empty():
		return
	var bounds := _computeBounds(positions)
	_targetPosition = bounds.get_center()
	var paddedSize := bounds.size + framingPadding * 2.0
	paddedSize.x = max(paddedSize.x, 1.0)
	paddedSize.y = max(paddedSize.y, 1.0)
	var viewportSize := get_viewport_rect().size
	var fitZoom := minf(viewportSize.x / paddedSize.x, viewportSize.y / paddedSize.y)
	_targetZoom = Vector2.ONE * clampf(fitZoom, minZoom, maxZoom)

func _onUnitChoicePhaseStarted() -> void:
	_framingActive = false
	_targetPosition = _defaultPosition
	_targetZoom = _defaultZoom

func _onBattlePhaseStarted() -> void:
	_framingActive = true
