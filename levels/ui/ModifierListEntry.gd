extends Label

signal hovered(entry: Control, description: String)
signal unhovered()

var modifierData: ModifierData
var _count: int = 1

func _ready() -> void:
	mouse_entered.connect(_onMouseEntered)
	mouse_exited.connect(_onMouseExited)

func setModifierData(data: ModifierData) -> void:
	modifierData = data
	_count = 1
	_updateLabel()

func incrementCount() -> void:
	_count += 1
	_updateLabel()

func _updateLabel() -> void:
	text = modifierData.modifierName if _count <= 1 else "%s x%d" % [modifierData.modifierName, _count]

func _onMouseEntered() -> void:
	hovered.emit(self, modifierData.description)

func _onMouseExited() -> void:
	unhovered.emit()
