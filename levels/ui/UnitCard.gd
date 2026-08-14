extends Control

@onready var portraitRect: TextureRect = %PortraitRect
@onready var nameLabel: Label = %NameLabel
@onready var roleLabel: Label = %RoleLabel
@onready var attackTypeLabel: Label = %AttackTypeLabel
@onready var hpLabel: Label = %HpLabel
@onready var damageLabel: Label = %DamageLabel
@onready var abilityLabel: Label = %AbilityLabel
@onready var selectButton: Button = %SelectButton

var unitData: UnitData

func _ready() -> void:
	selectButton.pressed.connect(_onSelectButtonPressed)

func _onSelectButtonPressed() -> void:
	EventBus.unit_selected.emit(unitData)

func setUnitData(data: UnitData) -> void:
	unitData = data
	nameLabel.text = data.unitName
	roleLabel.text = data.role
	attackTypeLabel.text = "Melee" if data.attackType == UnitData.AttackType.MELEE else "Ranged"
	hpLabel.text = "HP: %d" % data.maxHp
	damageLabel.text = "Damage: %d" % data.damage
	abilityLabel.text = data.abilityDescription
	portraitRect.texture = data.portrait
