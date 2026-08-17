class_name BuffDebuffComponent
extends Node2D

const FONT_SIZE = 12
const BUFF_COLOR = Color(0.2, 0.9, 0.2, 1.0)
const DEBUFF_COLOR = Color(1.0, 0.25, 0.2, 1.0)

@export var verticalOffset: float = -110.0

@onready var _combatComponent: CombatComponent = %CombatComponent
@onready var _vbox: VBoxContainer = _buildVBox()

func _buildVBox() -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.alignment = BoxContainer.ALIGNMENT_END
	vbox.resized.connect(_onVBoxResized)
	add_child(vbox)
	return vbox

func _process(_delta: float) -> void:
	if _combatComponent == null:
		return
	for child in _vbox.get_children():
		child.queue_free()
	for effect in _combatComponent.getActiveStatusEffects():
		_vbox.add_child(_buildLabel(effect))

func _buildLabel(effect: Dictionary) -> Label:
	var label := Label.new()
	if effect["permanent"]:
		label.text = "%s +%d" % [tr(effect["name"]), effect["stacks"]]
	elif effect["stacks"] > 1:
		label.text = "%s x%d %.1fs" % [tr(effect["name"]), effect["stacks"], effect["remaining"]]
	else:
		label.text = "%s %.1fs" % [tr(effect["name"]), effect["remaining"]]
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", FONT_SIZE)
	label.add_theme_color_override("font_color", BUFF_COLOR if effect["isBuff"] else DEBUFF_COLOR)
	return label

func _onVBoxResized() -> void:
	_vbox.position = Vector2(-_vbox.size.x / 2.0, verticalOffset - _vbox.size.y)
