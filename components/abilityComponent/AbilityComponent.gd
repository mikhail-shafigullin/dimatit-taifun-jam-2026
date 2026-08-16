class_name AbilityComponent
extends Node

const DOT_TICK_INTERVAL = 1.0

@onready var _body: CharacterBody2D = get_parent() as CharacterBody2D
@onready var _combatComponent: CombatComponent = %CombatComponent

var _abilities: Array[AbilityData] = []
var _cooldowns: Dictionary = {}

func _ready() -> void:
	EventBus.battle_phase_started.connect(_onBattlePhaseStarted)

func configure(abilities: Array[AbilityData]) -> void:
	_abilities = abilities
	_cooldowns.clear()
	for ability in _abilities:
		_cooldowns[ability] = 0.0
		if ability.type == AbilityData.AbilityType.EXECUTE:
			_combatComponent.setExecuteChance(ability.value, ability.duration)

func _process(delta: float) -> void:
	for ability in _abilities:
		if ability.type == AbilityData.AbilityType.GROWTH or ability.type == AbilityData.AbilityType.EXECUTE:
			continue
		_cooldowns[ability] = max(_cooldowns[ability] - delta, 0.0)
		if _cooldowns[ability] <= 0.0:
			_cast(ability)
			_cooldowns[ability] = ability.cooldown

func _onBattlePhaseStarted() -> void:
	for ability in _abilities:
		if ability.type == AbilityData.AbilityType.GROWTH:
			_castGrowth(ability)
		elif ability.type == AbilityData.AbilityType.OVERTIME:
			_combatComponent.resetStatGrowth(ability.abilityName)

func _cast(ability: AbilityData) -> void:
	match ability.type:
		AbilityData.AbilityType.TAUNT:
			_castTaunt(ability)
		AbilityData.AbilityType.DAMAGE_REDUCTION:
			_castDamageReduction(ability)
		AbilityData.AbilityType.HEAL:
			_castHeal(ability)
		AbilityData.AbilityType.STUN:
			_castStun(ability)
		AbilityData.AbilityType.ATTACK_DAMAGE_BUFF:
			_castDamageBuff(ability)
		AbilityData.AbilityType.DOT:
			_castDot(ability)
		AbilityData.AbilityType.OVERTIME:
			_castOvertime(ability)
		AbilityData.AbilityType.CLEANSE:
			_castCleanse(ability)
		AbilityData.AbilityType.COFFEE:
			_castCoffee(ability)

func _castTaunt(ability: AbilityData) -> void:
	for candidate in _getNearbyCombatants(_combatComponent.targetGroup, ability.radius):
		candidate.forceTarget(_combatComponent, ability.duration, ability.abilityName)

func _castDamageReduction(ability: AbilityData) -> void:
	for candidate in _getNearbyCombatants(_combatComponent.targetGroup, ability.radius):
		candidate.applyOutgoingDamageMultiplier(1.0 - ability.value, ability.duration, ability.abilityName, false)

func _castHeal(ability: AbilityData) -> void:
	for ally in _getNearbyCombatants(_combatComponent.ownGroup, ability.radius):
		ally.heal(int(round(ability.value)))

func _castCleanse(ability: AbilityData) -> void:
	for ally in _getNearbyCombatants(_combatComponent.ownGroup, ability.radius):
		ally.cleanseDebuffs()

func _castStun(ability: AbilityData) -> void:
	var nearest := _getNearestCombatant(_getNearbyCombatants(_combatComponent.targetGroup, ability.radius))
	if nearest != null:
		nearest.applyStun(ability.duration, ability.abilityName)

func _castGrowth(ability: AbilityData) -> void:
	if _combatComponent == null:
		return
	_combatComponent.addStatGrowth(ability.abilityName, int(round(ability.value)))

func _castOvertime(ability: AbilityData) -> void:
	if _combatComponent == null:
		return
	_combatComponent.addStatGrowth(ability.abilityName, int(round(ability.value)), ability.duration)

func _castDot(ability: AbilityData) -> void:
	for candidate in _getNearbyCombatants(_combatComponent.targetGroup, ability.radius):
		candidate.applyDot(int(round(ability.value)), DOT_TICK_INTERVAL, ability.duration, ability.abilityName)

func _castDamageBuff(ability: AbilityData) -> void:
	var allies := _getNearbyCombatants(_combatComponent.ownGroup, ability.radius)
	allies.erase(_combatComponent)
	var nearest := _getNearestCombatant(allies)
	if nearest != null:
		nearest.applyOutgoingDamageMultiplier(1.0 + ability.value, ability.duration, ability.abilityName, true)

func _castCoffee(ability: AbilityData) -> void:
	var allies := _getNearbyCombatants(_combatComponent.ownGroup, ability.radius)
	allies.erase(_combatComponent)
	var nearest := _getNearestCombatant(allies)
	if nearest != null:
		nearest.applyCoffee(ability.value, ability.duration, ability.abilityName)

func _getNearestCombatant(candidates: Array[CombatComponent]) -> CombatComponent:
	var nearest: CombatComponent = null
	var nearestDistance := INF
	for candidate in candidates:
		var dist := _body.global_position.distance_to(candidate.getGlobalPosition())
		if dist < nearestDistance:
			nearestDistance = dist
			nearest = candidate
	return nearest

func _getNearbyCombatants(group: String, radius: float) -> Array[CombatComponent]:
	var result: Array[CombatComponent] = []
	if _combatComponent == null or _body == null:
		return result
	for node in get_tree().get_nodes_in_group(group):
		var candidate := node as CombatComponent
		if candidate == null:
			continue
		if _body.global_position.distance_to(candidate.getGlobalPosition()) <= radius:
			result.append(candidate)
	return result
