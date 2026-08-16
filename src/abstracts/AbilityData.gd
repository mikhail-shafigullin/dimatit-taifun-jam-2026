class_name AbilityData
extends Resource

enum AbilityType { TAUNT, DAMAGE_REDUCTION, HEAL, STUN, ATTACK_DAMAGE_BUFF, GROWTH, DOT, OVERTIME, EXECUTE, CLEANSE, COFFEE }

@export var abilityName: String
@export_multiline var description: String
@export var type: AbilityType = AbilityType.TAUNT
@export var cooldown: float = 0.0
@export var value: float = 0.0
@export var radius: float = 0.0
@export var duration: float = 0.0
@export var icon: Texture2D
