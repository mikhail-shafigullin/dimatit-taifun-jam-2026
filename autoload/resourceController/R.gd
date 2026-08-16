extends Node

const UNIT_SCENE: PackedScene = preload("res://scenes/actors/units/Unit.tscn")
const ENEMY_SCENE: PackedScene = preload("res://scenes/actors/enemies/Enemy.tscn")

const UNIT_BORISTO: UnitData = preload("res://resources/units/BoristoData.tres")
const UNIT_BUHGALTER: UnitData = preload("res://resources/units/BuhgalterData.tres")
const UNIT_HR: UnitData = preload("res://resources/units/HRData.tres")
const UNIT_IT: UnitData = preload("res://resources/units/ITData.tres")
const UNIT_MANEGER: UnitData = preload("res://resources/units/ManegerData.tres")
const UNIT_MANG_PO_PROD: UnitData = preload("res://resources/units/MangPoProdData.tres")
const UNIT_OFFICE_CLERK: UnitData = preload("res://resources/units/OfficeClerkData.tres")
const UNIT_OHRANIK: UnitData = preload("res://resources/units/OhranikData.tres")
const UNIT_STAZHOR: UnitData = preload("res://resources/units/StazhorData.tres")
const UNIT_TOXIC: UnitData = preload("res://resources/units/ToxicData.tres")
const UNIT_TRUDOGOLIK: UnitData = preload("res://resources/units/TrudogolikData.tres")
const UNIT_UBORSHIK: UnitData = preload("res://resources/units/UborshikData.tres")

const UNIT_POOL: Array[UnitData] = [
	UNIT_BORISTO,
	UNIT_BUHGALTER,
	UNIT_HR,
	UNIT_IT,
	UNIT_MANEGER,
	UNIT_MANG_PO_PROD,
	UNIT_OFFICE_CLERK,
	UNIT_OHRANIK,
	UNIT_STAZHOR,
	UNIT_TOXIC,
	UNIT_TRUDOGOLIK,
	UNIT_UBORSHIK,
]

const ENEMY_BUMAGA: EnemyData = preload("res://resources/enemies/BumagaData.tres")
const ENEMY_FAX: EnemyData = preload("res://resources/enemies/FaxData.tres")
const ENEMY_KULER: EnemyData = preload("res://resources/enemies/KulerData.tres")
const ENEMY_NOZHNICI: EnemyData = preload("res://resources/enemies/NozhniciData.tres")
const ENEMY_PRINTER: EnemyData = preload("res://resources/enemies/PrinterData.tres")
const ENEMY_PROECTOR: EnemyData = preload("res://resources/enemies/ProectorData.tres")
const ENEMY_SHKAF: EnemyData = preload("res://resources/enemies/ShkafData.tres")
const ENEMY_SHREDER: EnemyData = preload("res://resources/enemies/ShrederData.tres")
const ENEMY_VIGOR_RAB: EnemyData = preload("res://resources/enemies/VigorRabData.tres")
const ENEMY_BOSS: EnemyData = preload("res://resources/enemies/BossData.tres")

## One entry per round; each entry lists every enemy to spawn that round.
const ROUND_ENEMIES: Array[Array] = [
	[ENEMY_BUMAGA],
	[ENEMY_FAX],
	[ENEMY_KULER],
	[ENEMY_NOZHNICI],
	[ENEMY_PRINTER, ENEMY_BUMAGA],
	[ENEMY_PROECTOR],
	[ENEMY_SHKAF],
	[ENEMY_SHREDER],
	[ENEMY_VIGOR_RAB],
	[ENEMY_BUMAGA, ENEMY_FAX, ENEMY_KULER],
	[ENEMY_PRINTER, ENEMY_PROECTOR],
	[ENEMY_SHKAF, ENEMY_SHREDER],
	[ENEMY_VIGOR_RAB, ENEMY_NOZHNICI, ENEMY_KULER],
	[ENEMY_PRINTER, ENEMY_SHREDER, ENEMY_BUMAGA],
	[ENEMY_BOSS, ENEMY_VIGOR_RAB, ENEMY_SHKAF],
]
