class_name Unit
extends CharacterBody2D

const HIT_FLASH_DURATION = 0.15
const DAMAGE_FLASH_SHADER = preload("res://assets/shaders/HitFlash.gdshader")
const DAMAGE_FLASH_DURATION = 0.15

@export var unitData: UnitData:
	set(value):
		unitData = value
		applyUnitData()

@onready var sprite: Sprite2D = %Sprite2D
@onready var shadow: Polygon2D = %Shadow
@onready var hitTimer: Timer = %HitTimer
@onready var damageFlashTimer: Timer = %DamageFlashTimer
@onready var combatComponent: CombatComponent = %CombatComponent
@onready var _damageFlashMaterial: ShaderMaterial = ShaderMaterial.new()

func _ready() -> void:
	hitTimer.wait_time = HIT_FLASH_DURATION
	hitTimer.timeout.connect(_onHitTimerTimeout)
	damageFlashTimer.wait_time = DAMAGE_FLASH_DURATION
	damageFlashTimer.timeout.connect(_onDamageFlashTimerTimeout)
	_damageFlashMaterial.shader = DAMAGE_FLASH_SHADER
	sprite.material = _damageFlashMaterial
	applyUnitData()

func setUnitData(data: UnitData) -> void:
	unitData = data

func applyUnitData() -> void:
	if unitData == null or sprite == null:
		return
	sprite.texture = unitData.idleSprite
	if shadow != null:
		shadow.position = unitData.shadowOffset
		shadow.scale = unitData.shadowScale
	if combatComponent != null:
		combatComponent.configure(unitData.maxHp, unitData.damage, unitData.attackSpeed, unitData.moveSpeed, unitData.attackRadius)

func playHitFlash() -> void:
	if unitData == null or unitData.hitSprite == null:
		return
	sprite.texture = unitData.hitSprite
	hitTimer.start()

func _onHitTimerTimeout() -> void:
	sprite.texture = unitData.idleSprite

func playDamageFlash() -> void:
	_damageFlashMaterial.set_shader_parameter("flashAmount", 1.0)
	damageFlashTimer.start()

func _onDamageFlashTimerTimeout() -> void:
	_damageFlashMaterial.set_shader_parameter("flashAmount", 0.0)
