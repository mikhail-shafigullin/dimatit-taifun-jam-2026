extends Control

@export var hoverScale: float = 1.08
@export var hoverScaleDuration: float = 0.15

@onready var iconRect: TextureRect = %IconRect
@onready var nameLabel: Label = %NameLabel
@onready var scopeLabel: Label = %ScopeLabel
@onready var durationLabel: Label = %DurationLabel
@onready var descriptionLabel: Label = %DescriptionLabel
@onready var selectButton: Button = %SelectButton

var modifierData: ModifierData
var _scaleTween: Tween

func _ready() -> void:
	selectButton.pressed.connect(_onSelectButtonPressed)
	resized.connect(_onResized)
	mouse_entered.connect(_onMouseEntered)
	mouse_exited.connect(_onMouseExited)

func _onSelectButtonPressed() -> void:
	EventBus.modifier_selected.emit(modifierData)

func _onResized() -> void:
	pivot_offset = size / 2.0

func _onMouseEntered() -> void:
	_tweenScale(Vector2.ONE * hoverScale)

func _onMouseExited() -> void:
	_tweenScale(Vector2.ONE)

func _tweenScale(targetScale: Vector2) -> void:
	if _scaleTween != null:
		_scaleTween.kill()
	_scaleTween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_scaleTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_scaleTween.tween_property(self, "scale", targetScale, hoverScaleDuration)

func setModifierData(data: ModifierData) -> void:
	modifierData = data
	nameLabel.text = data.modifierName
	scopeLabel.text = "All Units" if data.scope == ModifierData.ScopeType.GLOBAL else data.targetUnitType.unitName
	durationLabel.text = "Permanent" if data.durationType == ModifierData.DurationType.PERMANENT else "%d rounds" % data.durationRounds
	descriptionLabel.text = data.description
	iconRect.texture = data.icon
