extends Control

@export var hoverScale: float = 1.08
@export var hoverScaleDuration: float = 0.15

@onready var portraitRect: TextureRect = %PortraitRect
@onready var nameLabel: Label = %NameLabel
@onready var roleLabel: Label = %RoleLabel
@onready var attackTypeLabel: Label = %AttackTypeLabel
@onready var hpLabel: Label = %HpLabel
@onready var damageLabel: Label = %DamageLabel
@onready var abilityLabel: Label = %AbilityLabel
@onready var selectButton: Button = %SelectButton

var unitData: UnitData
var _scaleTween: Tween

func _ready() -> void:
	selectButton.pressed.connect(_onSelectButtonPressed)
	resized.connect(_onResized)
	mouse_entered.connect(_onMouseEntered)
	mouse_exited.connect(_onMouseExited)

func _onSelectButtonPressed() -> void:
	EventBus.unit_selected.emit(unitData)

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

func setUnitData(data: UnitData) -> void:
	unitData = data
	nameLabel.text = data.unitName
	roleLabel.text = data.role
	attackTypeLabel.text = "Melee" if data.attackType == UnitData.AttackType.MELEE else "Ranged"
	hpLabel.text = tr("HP: %d") % data.maxHp
	damageLabel.text = tr("Damage: %d") % data.damage
	if data.abilities.is_empty():
		abilityLabel.text = "No special ability"
	else:
		var abilityTexts: Array[String] = []
		for ability in data.abilities:
			abilityTexts.append("%s: %s" % [tr(ability.abilityName), tr(ability.description)])
		abilityLabel.text = "\n".join(abilityTexts)
	portraitRect.texture = data.idleSprite
