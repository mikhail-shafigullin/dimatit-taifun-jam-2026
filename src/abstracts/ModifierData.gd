class_name ModifierData
extends Resource

enum ScopeType { GLOBAL, UNIT_TYPE }
enum DurationType { PERMANENT, TEMPORARY }
enum StatType { MAX_HP, DAMAGE, ATTACK_SPEED, MOVE_SPEED }

@export var modifierName: String
@export_multiline var description: String
@export var icon: Texture2D
@export var scope: ScopeType = ScopeType.GLOBAL
@export var targetUnitType: UnitData
@export var durationType: DurationType = DurationType.PERMANENT
@export var durationRounds: int = 0
@export var statType: StatType = StatType.MAX_HP
@export var value: float = 0.0
