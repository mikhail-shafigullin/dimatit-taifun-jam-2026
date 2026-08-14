extends Control

@onready var card1: Control = %Card1
@onready var card2: Control = %Card2
@onready var card3: Control = %Card3
@onready var ignoreButton: Button = %IgnoreButton

func _ready() -> void:
	ignoreButton.pressed.connect(_onIgnoreButtonPressed)

func _onIgnoreButtonPressed() -> void:
	EventBus.unit_choice_ignored.emit()

func setChoices(units: Array[UnitData]) -> void:
	card1.setUnitData(units[0])
	card2.setUnitData(units[1])
	card3.setUnitData(units[2])
