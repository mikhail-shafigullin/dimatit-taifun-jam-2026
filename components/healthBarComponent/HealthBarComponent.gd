class_name HealthBarComponent
extends Node2D

const WIDTH = 40.0
const HEIGHT = 5.0
const BACKGROUND_COLOR = Color(0.1, 0.1, 0.1, 0.8)
const FILL_COLOR = Color(0.2, 0.9, 0.2, 1.0)

const DAMAGE_LABEL_COLOR = Color(1.0, 0.25, 0.2, 1.0)
const HEAL_LABEL_COLOR = Color(0.3, 1.0, 0.4, 1.0)
const FLOAT_LABEL_FONT_SIZE = 20
const DAMAGE_FLOAT_HEIGHT_MIN = 40.0
const DAMAGE_FLOAT_HEIGHT_MAX = 75.0
const DAMAGE_FLOAT_DRIFT = 30.0
const DAMAGE_FLOAT_DURATION_MIN = 0.5
const DAMAGE_FLOAT_DURATION_MAX = 0.9

@export var verticalOffset: float = -50.0

@onready var _combatComponent: CombatComponent = %CombatComponent

var _hpRatio: float = 1.0

func _ready() -> void:
	position = Vector2(-WIDTH / 2.0, verticalOffset)
	if _combatComponent != null:
		_combatComponent.hp_changed.connect(_onHpChanged)
		_combatComponent.damage_taken.connect(_onDamageTaken)
		_combatComponent.healed.connect(_onHealed)
		_onHpChanged(_combatComponent.getCurrentHp(), _combatComponent.getMaxHp())

func _onHpChanged(currentHp: int, maxHp: int) -> void:
	_hpRatio = clampf(float(currentHp) / float(max(maxHp, 1)), 0.0, 1.0)
	queue_redraw()

func _onDamageTaken(amount: int) -> void:
	_spawnFloatingLabel("-%d" % amount, DAMAGE_LABEL_COLOR)

func _onHealed(amount: int) -> void:
	_spawnFloatingLabel("+%d" % amount, HEAL_LABEL_COLOR)

func _spawnFloatingLabel(text: String, color: Color) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", FLOAT_LABEL_FONT_SIZE)
	label.z_index = 100
	get_tree().current_scene.add_child(label)
	label.global_position = get_parent().global_position + Vector2(randf_range(-10.0, 10.0), verticalOffset)

	var floatHeight := randf_range(DAMAGE_FLOAT_HEIGHT_MIN, DAMAGE_FLOAT_HEIGHT_MAX)
	var drift := randf_range(-DAMAGE_FLOAT_DRIFT, DAMAGE_FLOAT_DRIFT)
	var duration := randf_range(DAMAGE_FLOAT_DURATION_MIN, DAMAGE_FLOAT_DURATION_MAX)
	var startPosition := label.global_position

	var tween := label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "global_position", startPosition + Vector2(drift, -floatHeight), duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, duration * 0.4).set_delay(duration * 0.6)
	tween.chain().tween_callback(label.queue_free)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(WIDTH, HEIGHT)), BACKGROUND_COLOR)
	draw_rect(Rect2(Vector2.ZERO, Vector2(WIDTH * _hpRatio, HEIGHT)), FILL_COLOR)
