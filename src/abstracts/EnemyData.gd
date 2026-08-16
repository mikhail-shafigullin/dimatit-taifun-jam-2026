class_name EnemyData
extends Resource

enum AttackType { MELEE, RANGED }

@export var enemyName: String
@export var category: String
@export var tier: String
@export var attackType: AttackType = AttackType.MELEE
@export var isStationary: bool = false
@export var maxHp: int = 0
@export var damage: int = 0
@export var attackSpeed: float = 0.0
@export var moveSpeed: float = 0.0
@export var attackRadius: float = 0.0
@export var abilities: Array[AbilityData] = []
@export var portrait: Texture2D
@export var idleSprite: Texture2D
@export var hitSprite: Texture2D
@export var shadowOffset: Vector2 = Vector2(0, 50)
@export var shadowScale: Vector2 = Vector2(1.2, 1.2)
