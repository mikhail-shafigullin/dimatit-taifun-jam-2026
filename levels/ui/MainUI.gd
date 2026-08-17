extends Control

const ModifierListEntryScene := preload("res://levels/ui/ModifierListEntry.tscn")

@onready var entriesBox: VBoxContainer = %ModifierList
@onready var descriptionPopup: PanelContainer = %DescriptionPopup
@onready var descriptionLabel: Label = %DescriptionLabel

var _entriesByName: Dictionary = {}

func _ready() -> void:
	descriptionPopup.hide()
	EventBus.modifier_selected.connect(_onModifierSelected)
	for modifierData in Global.addedModifiers:
		_addModifier(modifierData)

func _onModifierSelected(modifier_data: ModifierData) -> void:
	_addModifier(modifier_data)

func _addModifier(data: ModifierData) -> void:
	if _entriesByName.has(data.modifierName):
		var entry: Label = _entriesByName[data.modifierName]
		entry.incrementCount()
	else:
		var entry := ModifierListEntryScene.instantiate()
		entriesBox.add_child(entry)
		entry.setModifierData(data)
		entry.hovered.connect(_onEntryHovered)
		entry.unhovered.connect(_onEntryUnhovered)
		_entriesByName[data.modifierName] = entry

func _onEntryHovered(entry: Control, description: String) -> void:
	descriptionLabel.text = description
	descriptionPopup.global_position = entry.global_position + Vector2(-descriptionPopup.size.x - 8, 0)
	descriptionPopup.show()

func _onEntryUnhovered() -> void:
	descriptionPopup.hide()
