class_name CombatComponent
extends Node

const KNOCKBACK_SPEED = 220.0
const KNOCKBACK_DURATION = 0.15
const KNOCKBACK_FRICTION = 900.0
const SEPARATION_STRENGTH = 10.0
const COMBATANTS_GROUP = "combatants"

signal died()

@export var ownGroup: String = ""
@export var targetGroup: String = ""

@onready var _body: CharacterBody2D = get_parent() as CharacterBody2D
@onready var _collisionRadius: float = _resolveCollisionRadius()

var _damage: int = 0
var _attackSpeed: float = 1.0
var _moveSpeed: float = 0.0
var _attackRadius: float = 0.0
var _currentHp: int = 0
var _attackCooldown: float = 0.0
var _target: CombatComponent = null
var _knockbackVelocity: Vector2 = Vector2.ZERO
var _knockbackTimer: float = 0.0

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
	return 16.0

func configure(maxHp: int, damage: int, attackSpeed: float, moveSpeed: float, attackRadius: float) -> void:
	_currentHp = maxHp
	_damage = damage
	_attackSpeed = attackSpeed
	_moveSpeed = moveSpeed
	_attackRadius = attackRadius

func _physics_process(delta: float) -> void:
	if _body == null:
		return

	_attackCooldown = max(_attackCooldown - delta, 0.0)

	var moveVelocity := Vector2.ZERO

	if _knockbackTimer > 0.0:
		_knockbackTimer -= delta
		_knockbackVelocity = _knockbackVelocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
		moveVelocity = _knockbackVelocity
	else:
		_target = _findNearestTarget()
		if _target != null:
			var toTarget := _target._body.global_position - _body.global_position
			if toTarget.length() > _attackRadius:
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
		var otherRadius := otherCombat._collisionRadius if otherCombat != null else 16.0
		var offset := _body.global_position - other.global_position
		var dist := offset.length()
		var minDist := _collisionRadius + otherRadius
		if dist < minDist and dist > 0.001:
			push += offset.normalized() * (minDist - dist) * SEPARATION_STRENGTH
	return push

func _findNearestTarget() -> CombatComponent:
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
	_attackCooldown = 1.0 / max(_attackSpeed, 0.01)
	_target.applyDamage(_damage, _body.global_position)

func applyDamage(amount: int, sourcePosition: Vector2) -> void:
	_currentHp -= amount
	if _body != null and _body.has_method("playHitFlash"):
		_body.playHitFlash()
	var knockDirection := _body.global_position - sourcePosition
	knockDirection = knockDirection.normalized() if knockDirection != Vector2.ZERO else Vector2.RIGHT
	_knockbackVelocity = knockDirection * KNOCKBACK_SPEED
	_knockbackTimer = KNOCKBACK_DURATION
	if _currentHp <= 0:
		died.emit()
		_body.queue_free()
