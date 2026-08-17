class_name CombatComponent
extends Node

const KNOCKBACK_SPEED_DEFAULT = 220.0
const KNOCKBACK_SPEED_FROM_ENEMY = 480.0
const KNOCKBACK_DURATION = 0.15
const KNOCKBACK_FRICTION = 900.0
const SEPARATION_STRENGTH = 10.0
const COMBATANTS_GROUP = "combatants"
const CAFFEINE_CRASH_NAME = "Caffeine Crash"
const CAFFEINE_CRASH_DURATION = 3.0

signal died()
signal hp_changed(currentHp: int, maxHp: int)
signal damage_taken(amount: int)
signal healed(amount: int)

@export var ownGroup: String = ""
@export var targetGroup: String = ""

@onready var _body: CharacterBody2D = get_parent() as CharacterBody2D
@onready var _collisionRadius: float = _resolveCollisionRadius()

var _damage: int = 0
var _attackSpeed: float = 1.0
var _moveSpeed: float = 0.0
var _attackRadius: float = 0.0
var _maxHp: int = 0
var _currentHp: int = 0
var _attackCooldown: float = 0.0
var _target: CombatComponent = null
var _knockbackVelocity: Vector2 = Vector2.ZERO
var _knockbackTimer: float = 0.0
var _forcedTarget: CombatComponent = null
var _forcedTargetTimer: float = 0.0
var _outgoingDamageMultiplier: float = 1.0
var _outgoingDamageMultiplierTimer: float = 0.0
var _stunTimer: float = 0.0
var _damageBonus: int = 0
var _attackSpeedBonus: float = 0.0
var _dotDamagePerTick: int = 0
var _dotTickInterval: float = 1.0
var _dotTickTimer: float = 0.0
var _dotTimer: float = 0.0
var _executeChance: float = 0.0
var _executeHpThreshold: float = 0.0
var _coffeeStacks: int = 0
var _coffeeAttackSpeedBonus: float = 0.0
var _coffeeTimer: float = 0.0
var _crashPenalty: float = 0.0
var _crashTimer: float = 0.0
var _statusEffects: Dictionary = {}
var _baseMaxHp: int = 0
var _baseDamage: int = 0
var _baseAttackSpeed: float = 0.0
var _baseMoveSpeed: float = 0.0
var _activeModifiers: Array[ModifierData] = []

func _ready() -> void:
	if not ownGroup.is_empty():
		add_to_group(ownGroup)
	if _body != null:
		_body.add_to_group(COMBATANTS_GROUP)

func _resolveCollisionRadius() -> float:
	if _body == null:
		return 16.0
	var shape := _body.get_node_or_null("%CollisionShape2D") as CollisionShape2D
	if shape != null and shape.shape is CircleShape2D:
		return (shape.shape as CircleShape2D).radius
	if shape != null and shape.shape is CapsuleShape2D:
		return (shape.shape as CapsuleShape2D).radius
	return 16.0

func configure(maxHp: int, damage: int, attackSpeed: float, moveSpeed: float, attackRadius: float) -> void:
	_baseMaxHp = maxHp
	_baseDamage = damage
	_baseAttackSpeed = attackSpeed
	_baseMoveSpeed = moveSpeed
	_attackRadius = attackRadius
	_recomputeModifiedStats()
	_currentHp = _maxHp
	hp_changed.emit(_currentHp, _maxHp)

func getCurrentHp() -> int:
	return _currentHp

func getMaxHp() -> int:
	return _maxHp

func getBody() -> CharacterBody2D:
	return _body

## Recomputes effective stats from base stats and every active ModifierData, so stacked
## percentage bonuses always derive from the same baseline instead of compounding on reapply.
func _recomputeModifiedStats() -> void:
	var hpMultiplier := 1.0
	var damageMultiplier := 1.0
	var attackSpeedMultiplier := 1.0
	var moveSpeedMultiplier := 1.0
	for modifier in _activeModifiers:
		match modifier.statType:
			ModifierData.StatType.MAX_HP:
				hpMultiplier += modifier.value
			ModifierData.StatType.DAMAGE:
				damageMultiplier += modifier.value
			ModifierData.StatType.ATTACK_SPEED:
				attackSpeedMultiplier += modifier.value
			ModifierData.StatType.MOVE_SPEED:
				moveSpeedMultiplier += modifier.value
	var missingHp := _maxHp - _currentHp
	_maxHp = int(round(_baseMaxHp * hpMultiplier))
	_currentHp = clampi(_maxHp - missingHp, 0, _maxHp)
	_damage = int(round(_baseDamage * damageMultiplier))
	_attackSpeed = _baseAttackSpeed * attackSpeedMultiplier
	_moveSpeed = _baseMoveSpeed * moveSpeedMultiplier
	hp_changed.emit(_currentHp, _maxHp)

func applyModifier(modifier: ModifierData) -> void:
	_activeModifiers.append(modifier)
	_recomputeModifiedStats()
	if not _statusEffects.has(modifier.modifierName):
		_statusEffects[modifier.modifierName] = { "remaining": 0.0, "isBuff": true, "permanent": true, "stacks": 0 }
	_statusEffects[modifier.modifierName]["stacks"] += 1

func removeModifier(modifier: ModifierData) -> void:
	_activeModifiers.erase(modifier)
	_recomputeModifiedStats()
	if not _statusEffects.has(modifier.modifierName):
		return
	_statusEffects[modifier.modifierName]["stacks"] -= 1
	if _statusEffects[modifier.modifierName]["stacks"] <= 0:
		_statusEffects.erase(modifier.modifierName)

func _physics_process(delta: float) -> void:
	if _body == null:
		return

	_attackCooldown = max(_attackCooldown - delta, 0.0)

	if _forcedTargetTimer > 0.0:
		_forcedTargetTimer -= delta
		if _forcedTargetTimer <= 0.0:
			_forcedTarget = null
	if _outgoingDamageMultiplierTimer > 0.0:
		_outgoingDamageMultiplierTimer -= delta
		if _outgoingDamageMultiplierTimer <= 0.0:
			_outgoingDamageMultiplier = 1.0
	if _dotTimer > 0.0:
		_dotTickTimer -= delta
		if _dotTickTimer <= 0.0:
			_dotTickTimer += _dotTickInterval
			applyDamage(_dotDamagePerTick, _body.global_position)
		_dotTimer = max(_dotTimer - delta, 0.0)
	if _coffeeTimer > 0.0:
		_coffeeTimer -= delta
		if _coffeeTimer <= 0.0:
			_triggerCaffeineCrash()
	if _crashTimer > 0.0:
		_crashTimer -= delta
		if _crashTimer <= 0.0:
			_crashPenalty = 0.0

	for effectName in _statusEffects.keys():
		if _statusEffects[effectName]["permanent"]:
			continue
		_statusEffects[effectName]["remaining"] -= delta
		if _statusEffects[effectName]["remaining"] <= 0.0:
			_statusEffects.erase(effectName)

	var moveVelocity := Vector2.ZERO

	if _knockbackTimer > 0.0:
		_knockbackTimer -= delta
		_knockbackVelocity = _knockbackVelocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
		moveVelocity = _knockbackVelocity
	elif _stunTimer > 0.0:
		_stunTimer -= delta
	else:
		_target = _findNearestTarget()
		if _target != null:
			var toTarget := _target._body.global_position - _body.global_position
			var edgeDistance := toTarget.length() - _collisionRadius - _target._collisionRadius
			if edgeDistance > _attackRadius:
				moveVelocity = toTarget.normalized() * _moveSpeed
			else:
				_tryAttack()

	_body.velocity = moveVelocity + _computeSeparation()
	_body.move_and_slide()

## Pushes this body apart from any overlapping combatant, proportional to overlap depth,
## so crowding feels like a soft spring rather than a hard block or a flat slide.
func _computeSeparation() -> Vector2:
	var push := Vector2.ZERO
	for node in get_tree().get_nodes_in_group(COMBATANTS_GROUP):
		if node == _body:
			continue
		var other := node as CharacterBody2D
		if other == null:
			continue
		var otherCombat := other.get_node_or_null("%CombatComponent") as CombatComponent
		if otherCombat != null and otherCombat.ownGroup == ownGroup:
			continue
		var otherRadius := otherCombat._collisionRadius if otherCombat != null else 16.0
		var offset := _body.global_position - other.global_position
		var dist := offset.length()
		var minDist := _collisionRadius + otherRadius
		if dist < minDist and dist > 0.001:
			push += offset.normalized() * (minDist - dist) * SEPARATION_STRENGTH
	return push

func _findNearestTarget() -> CombatComponent:
	if _forcedTarget != null:
		if is_instance_valid(_forcedTarget) and is_instance_valid(_forcedTarget._body):
			return _forcedTarget
		_forcedTarget = null
	if targetGroup.is_empty():
		return null
	var nearest: CombatComponent = null
	var nearestDistance := INF
	for node in get_tree().get_nodes_in_group(targetGroup):
		var candidate := node as CombatComponent
		if candidate == null or candidate._body == null:
			continue
		var dist := _body.global_position.distance_to(candidate._body.global_position)
		if dist < nearestDistance:
			nearestDistance = dist
			nearest = candidate
	return nearest

func _tryAttack() -> void:
	if _target == null or _attackCooldown > 0.0:
		return
	_attackCooldown = 1.0 / max(_attackSpeed + _attackSpeedBonus + _coffeeAttackSpeedBonus - _crashPenalty, 0.01)
	if _body != null and _body.has_method("playHitFlash"):
		_body.playHitFlash()
	if _executeChance > 0.0 and _target.getCurrentHp() <= _target.getMaxHp() * _executeHpThreshold and randf() < _executeChance:
		_target.execute(_body.global_position, ownGroup)
		return
	var finalDamage := int(round((_damage + _damageBonus) * _outgoingDamageMultiplier))
	_target.applyDamage(finalDamage, _body.global_position, ownGroup)

func setExecuteChance(chance: float, hpThreshold: float) -> void:
	_executeChance = chance
	_executeHpThreshold = hpThreshold

func execute(sourcePosition: Vector2, sourceGroup: String = "") -> void:
	applyDamage(_currentHp, sourcePosition, sourceGroup)

func cleanseDebuffs() -> void:
	_forcedTarget = null
	_forcedTargetTimer = 0.0
	_stunTimer = 0.0
	_dotTimer = 0.0
	_dotTickTimer = 0.0
	_dotDamagePerTick = 0
	if _outgoingDamageMultiplier < 1.0:
		_outgoingDamageMultiplier = 1.0
		_outgoingDamageMultiplierTimer = 0.0
	_crashPenalty = 0.0
	_crashTimer = 0.0
	for effectName in _statusEffects.keys():
		if not _statusEffects[effectName]["isBuff"]:
			_statusEffects.erase(effectName)

func heal(amount: int) -> void:
	var previousHp := _currentHp
	_currentHp = min(_currentHp + amount, _maxHp)
	var actualHeal := _currentHp - previousHp
	if actualHeal <= 0:
		return
	hp_changed.emit(_currentHp, _maxHp)
	healed.emit(actualHeal)

func getGlobalPosition() -> Vector2:
	return _body.global_position if _body != null else Vector2.ZERO

func forceTarget(source: CombatComponent, duration: float, effectName: String) -> void:
	_forcedTarget = source
	_forcedTargetTimer = duration
	_setStatusEffect(effectName, duration, false)

func applyOutgoingDamageMultiplier(multiplier: float, duration: float, effectName: String, isBuff: bool) -> void:
	_outgoingDamageMultiplier = multiplier
	_outgoingDamageMultiplierTimer = duration
	_setStatusEffect(effectName, duration, isBuff)

func applyStun(duration: float, effectName: String) -> void:
	_stunTimer = max(_stunTimer, duration)
	_setStatusEffect(effectName, duration, false)

func applyDot(damagePerTick: int, tickInterval: float, duration: float, effectName: String) -> void:
	_dotDamagePerTick = damagePerTick
	_dotTickInterval = max(tickInterval, 0.01)
	_dotTickTimer = _dotTickInterval
	_dotTimer = duration
	_setStatusEffect(effectName, duration, false)

func applyCoffee(bonusPerStack: float, duration: float, effectName: String) -> void:
	_coffeeStacks += 1
	_coffeeAttackSpeedBonus += bonusPerStack
	_coffeeTimer = duration
	_statusEffects[effectName] = { "remaining": duration, "isBuff": true, "permanent": false, "stacks": _coffeeStacks }

func _triggerCaffeineCrash() -> void:
	_crashPenalty = _coffeeAttackSpeedBonus
	_crashTimer = CAFFEINE_CRASH_DURATION
	_coffeeStacks = 0
	_coffeeAttackSpeedBonus = 0.0
	_setStatusEffect(CAFFEINE_CRASH_NAME, _crashTimer, false)

func addStatGrowth(effectName: String, damagePerStack: int, attackSpeedPerStack: float = 0.0) -> void:
	if not _statusEffects.has(effectName):
		_statusEffects[effectName] = { "remaining": 0.0, "isBuff": true, "permanent": true, "stacks": 0 }
	_statusEffects[effectName]["stacks"] += 1
	_damageBonus += damagePerStack
	_attackSpeedBonus += attackSpeedPerStack

func resetStatGrowth(effectName: String) -> void:
	if not _statusEffects.has(effectName):
		return
	_statusEffects.erase(effectName)
	_damageBonus = 0
	_attackSpeedBonus = 0.0

func _setStatusEffect(effectName: String, duration: float, isBuff: bool) -> void:
	_statusEffects[effectName] = { "remaining": duration, "isBuff": isBuff, "permanent": false, "stacks": 0 }

func getActiveStatusEffects() -> Array[Dictionary]:
	var effects: Array[Dictionary] = []
	for effectName in _statusEffects.keys():
		var effect: Dictionary = _statusEffects[effectName]
		effects.append({
			"name": effectName,
			"remaining": effect["remaining"],
			"isBuff": effect["isBuff"],
			"permanent": effect["permanent"],
			"stacks": effect["stacks"],
		})
	return effects

## Allied hits never knock the target back (so units don't shove enemies around),
## while enemy hits knock allied units back further than before for more readable impact.
func applyDamage(amount: int, sourcePosition: Vector2, sourceGroup: String = "") -> void:
	_currentHp -= amount
	hp_changed.emit(max(_currentHp, 0), _maxHp)
	damage_taken.emit(amount)
	if _body != null and _body.has_method("playDamageFlash"):
		_body.playDamageFlash()
	if sourceGroup != "units":
		var knockDirection := _body.global_position - sourcePosition
		knockDirection = knockDirection.normalized() if knockDirection != Vector2.ZERO else Vector2.RIGHT
		var knockbackSpeed := KNOCKBACK_SPEED_FROM_ENEMY if sourceGroup == "enemies" else KNOCKBACK_SPEED_DEFAULT
		_knockbackVelocity = knockDirection * knockbackSpeed
		_knockbackTimer = KNOCKBACK_DURATION
	if _currentHp <= 0:
		died.emit()
		_body.queue_free()
