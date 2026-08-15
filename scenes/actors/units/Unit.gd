class_name Unit
extends CharacterBody2D

const HIT_FLASH_DURATION = 0.15

@export var unitData: UnitData:
	set(value):
		unitData = value
		applyUnitData()

@onready var sprite: Sprite2D = %Sprite2D
@onready var hitTimer: Timer = %HitTimer
@onready var combatComponent: CombatComponent = %CombatComponent

func _ready() -> void:
	hitTimer.wait_time = HIT_FLASH_DURATION
	hitTimer.timeout.connect(_onHitTimerTimeout)
	applyUnitData()

func setUnitData(data: UnitData) -> void:
	unitData = data

func applyUnitData() -> void:
	if unitData == null or sprite == null:
		return
	sprite.texture = unitData.idleSprite
	if combatComponent != null:
		combatComponent.configure(unitData.maxHp, unitData.damage, unitData.attackSpeed, unitData.moveSpeed, unitData.attackRadius)

func playHitFlash() -> void:
	if unitData == null or unitData.hitSprite == null:
		return
	sprite.texture = unitData.hitSprite
	hitTimer.start()

func _onHitTimerTimeout() -> void:
	sprite.texture = unitData.idleSprite
