class_name UnitData
extends Resource

enum AttackType { MELEE, RANGED }

@export var unitName: String
@export var role: String
@export var attackType: AttackType = AttackType.MELEE
@export var maxHp: int = 0
@export var damage: int = 0
@export var attackSpeed: float = 0.0
@export var moveSpeed: float = 0.0
@export var attackRadius: float = 0.0
@export var abilities: Array[AbilityData] = []
@export var portrait: Texture2D
@export var idleSprite: Texture2D
@export var hitSprite: Texture2D
@export var shadowOffset: Vector2 = Vector2(5, 51)
@export var shadowScale: Vector2 = Vector2(0.4, 0.4)
