extends Node

const CHOICES_PER_ROUND = 3
const UNIT_SPAWN_AREA = Rect2(550.0, 150.0, 250.0, 400.0)
const ENEMY_SPAWN_AREA = Rect2(150.0, 100.0, 200.0, 400.0)

var unitChoicesAvailable: int = 3
var currentRound: int = 0

var _selectionActive: bool = false
var _battleActive: bool = false

func _ready() -> void:
	EventBus.unit_selected.connect(_onUnitSelected)
	EventBus.unit_choice_ignored.connect(_onUnitChoiceIgnored)

func _process(_delta: float) -> void:
	if not _battleActive:
		return
	var enemiesAlive := not get_tree().get_nodes_in_group("enemies").is_empty()
	if not enemiesAlive:
		_onRoundEnded()
		return
	var unitsAlive := not get_tree().get_nodes_in_group("units").is_empty()
	if not unitsAlive:
		_onRoundEnded()

## Called on victory (all enemies dead) or defeat (all units dead) to open the next unit pick.
func _onRoundEnded() -> void:
	_battleActive = false
	addUnitChoice()
	showAddUnitInterface()

## Shows the picker once per remaining unitChoicesAvailable, consuming them one by one.
func showAddUnitInterface() -> void:
	if _selectionActive or unitChoicesAvailable <= 0:
		return
	_selectionActive = true
	get_tree().paused = true
	EventBus.unit_choice_phase_started.emit()
	_presentNextChoice()

func addUnitChoice(amount: int = 1) -> void:
	unitChoicesAvailable += amount

func _presentNextChoice() -> void:
	var chooseUnitUi := get_tree().get_first_node_in_group("chooseUnitUi") as Control
	if chooseUnitUi == null:
		return
	var shuffledPool := R.UNIT_POOL.duplicate()
	shuffledPool.shuffle()
	var roundChoices: Array[UnitData] = []
	for offset in CHOICES_PER_ROUND:
		roundChoices.append(shuffledPool[offset])
	chooseUnitUi.setChoices(roundChoices)
	chooseUnitUi.show()

func _onUnitSelected(data: UnitData) -> void:
	if not _selectionActive:
		return
	_spawnUnit(data)
	_consumeChoice()

func _onUnitChoiceIgnored() -> void:
	if not _selectionActive:
		return
	_consumeChoice()

func _consumeChoice() -> void:
	unitChoicesAvailable -= 1
	if unitChoicesAvailable > 0:
		_presentNextChoice()
	else:
		_selectionActive = false
		get_tree().paused = false
		var chooseUnitUi := get_tree().get_first_node_in_group("chooseUnitUi") as Control
		if chooseUnitUi != null:
			chooseUnitUi.hide()
		_repositionSurvivingUnits()
		_spawnRoundEnemies()
		EventBus.battle_phase_started.emit()

func _spawnUnit(data: UnitData) -> void:
	var currentScene := get_tree().current_scene
	if currentScene == null:
		return
	var unit := R.UNIT_SCENE.instantiate() as Unit
	unit.unitData = data
	unit.position = Vector2(
		randf_range(UNIT_SPAWN_AREA.position.x, UNIT_SPAWN_AREA.end.x),
		randf_range(UNIT_SPAWN_AREA.position.y, UNIT_SPAWN_AREA.end.y)
	)
	currentScene.add_child(unit)

func _repositionSurvivingUnits() -> void:
	for combatComponent in get_tree().get_nodes_in_group("units"):
		var body := combatComponent.get_parent() as Node2D
		if body == null:
			continue
		body.position = Vector2(
			randf_range(UNIT_SPAWN_AREA.position.x, UNIT_SPAWN_AREA.end.x),
			randf_range(UNIT_SPAWN_AREA.position.y, UNIT_SPAWN_AREA.end.y)
		)

func _spawnRoundEnemies() -> void:
	var currentScene := get_tree().current_scene
	if currentScene == null:
		return
	var roundIndex := clampi(currentRound, 0, R.ROUND_ENEMIES.size() - 1)
	for enemyData in R.ROUND_ENEMIES[roundIndex]:
		var enemy := R.ENEMY_SCENE.instantiate() as Enemy
		enemy.enemyData = enemyData
		enemy.position = Vector2(
			randf_range(ENEMY_SPAWN_AREA.position.x, ENEMY_SPAWN_AREA.end.x),
			randf_range(ENEMY_SPAWN_AREA.position.y, ENEMY_SPAWN_AREA.end.y)
		)
		currentScene.add_child(enemy)
	currentRound = min(currentRound + 1, R.ROUND_ENEMIES.size() - 1)
	_battleActive = true
