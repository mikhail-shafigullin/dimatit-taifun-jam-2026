extends Control

@onready var card1: Control = %Card1
@onready var card2: Control = %Card2
@onready var card3: Control = %Card3
@onready var ignoreButton: Button = %IgnoreButton

func _ready() -> void:
	visible = false
	add_to_group("chooseModifierUi")
	ignoreButton.pressed.connect(_onIgnoreButtonPressed)

func _onIgnoreButtonPressed() -> void:
	EventBus.modifier_choice_ignored.emit()

func setChoices(modifiers: Array[ModifierData]) -> void:
	card1.setModifierData(modifiers[0])
	card2.setModifierData(modifiers[1])
	card3.setModifierData(modifiers[2])
