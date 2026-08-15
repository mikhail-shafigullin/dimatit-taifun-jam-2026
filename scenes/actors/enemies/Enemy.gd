class_name Enemy
extends CharacterBody2D

const HIT_FLASH_DURATION = 0.15

@export var enemyData: EnemyData:
	set(value):
		enemyData = value
		applyEnemyData()

@onready var sprite: Sprite2D = %Sprite2D
@onready var hitTimer: Timer = %HitTimer
@onready var combatComponent: CombatComponent = %CombatComponent

func _ready() -> void:
	hitTimer.wait_time = HIT_FLASH_DURATION
	hitTimer.timeout.connect(_onHitTimerTimeout)
	applyEnemyData()

func setEnemyData(data: EnemyData) -> void:
	enemyData = data

func applyEnemyData() -> void:
	if enemyData == null or sprite == null:
		return
	sprite.texture = enemyData.idleSprite
	if combatComponent != null:
		combatComponent.configure(enemyData.maxHp, enemyData.damage, enemyData.attackSpeed, enemyData.moveSpeed, enemyData.attackRadius)

func playHitFlash() -> void:
	if enemyData == null or enemyData.hitSprite == null:
		return
	sprite.texture = enemyData.hitSprite
	hitTimer.start()

func _onHitTimerTimeout() -> void:
	sprite.texture = enemyData.idleSprite
