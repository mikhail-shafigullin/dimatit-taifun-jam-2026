class_name UnitData
extends Resource

enum AttackType { MELEE, RANGED }

@export var unitName: String
@export var role: String
@export var attackType: AttackType = AttackType.MELEE
@export var maxHp: int = 0
@export var damage: int = 0
@export_multiline var abilityDescription: String
@export var portrait: Texture2D
