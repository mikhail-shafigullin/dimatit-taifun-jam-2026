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

const MODIFIER_ERGONOMIC_CHAIR: ModifierData = preload("res://resources/modifiers/ErgonomicChairData.tres")
const MODIFIER_SHARPENED_PENCIL: ModifierData = preload("res://resources/modifiers/SharpenedPencilData.tres")
const MODIFIER_NERVES_OF_STEEL: ModifierData = preload("res://resources/modifiers/NervesOfSteelData.tres")
const MODIFIER_BATON_UPGRADE: ModifierData = preload("res://resources/modifiers/BatonUpgradeData.tres")
const MODIFIER_STRESS_BALL: ModifierData = preload("res://resources/modifiers/StressBallData.tres")
const MODIFIER_RED_STAPLER: ModifierData = preload("res://resources/modifiers/RedStaplerData.tres")
const MODIFIER_WELLNESS_PROGRAM: ModifierData = preload("res://resources/modifiers/WellnessProgramData.tres")
const MODIFIER_PERFORMANCE_REVIEW: ModifierData = preload("res://resources/modifiers/PerformanceReviewData.tres")
const MODIFIER_BACKUP_SERVER: ModifierData = preload("res://resources/modifiers/BackupServerData.tres")
const MODIFIER_OVERCLOCKED_RIG: ModifierData = preload("res://resources/modifiers/OverclockedRigData.tres")
const MODIFIER_CORNER_OFFICE: ModifierData = preload("res://resources/modifiers/CornerOfficeData.tres")
const MODIFIER_POWER_SUIT: ModifierData = preload("res://resources/modifiers/PowerSuitData.tres")
const MODIFIER_ENERGY_DRINK: ModifierData = preload("res://resources/modifiers/EnergyDrinkData.tres")
const MODIFIER_OVERACHIEVER: ModifierData = preload("res://resources/modifiers/OverachieverData.tres")
const MODIFIER_THICK_SKIN: ModifierData = preload("res://resources/modifiers/ThickSkinData.tres")
const MODIFIER_TOXIC_ATMOSPHERE: ModifierData = preload("res://resources/modifiers/ToxicAtmosphereData.tres")
const MODIFIER_IRON_CONSTITUTION: ModifierData = preload("res://resources/modifiers/IronConstitutionData.tres")
const MODIFIER_EXTRA_SHIFT: ModifierData = preload("res://resources/modifiers/ExtraShiftData.tres")
const MODIFIER_COMPANY_CAR: ModifierData = preload("res://resources/modifiers/CompanyCarData.tres")
const MODIFIER_SALES_MOTIVATION: ModifierData = preload("res://resources/modifiers/SalesMotivationData.tres")
const MODIFIER_STEEL_TOE_BOOTS: ModifierData = preload("res://resources/modifiers/SteelToeBootsData.tres")
const MODIFIER_INDUSTRIAL_CLEANER: ModifierData = preload("res://resources/modifiers/IndustrialCleanerData.tres")
const MODIFIER_THERMAL_MUG: ModifierData = preload("res://resources/modifiers/ThermalMugData.tres")
const MODIFIER_DOUBLE_ESPRESSO: ModifierData = preload("res://resources/modifiers/DoubleEspressoData.tres")

const MODIFIER_POOL: Array[ModifierData] = [
	MODIFIER_ERGONOMIC_CHAIR,
	MODIFIER_SHARPENED_PENCIL,
	MODIFIER_NERVES_OF_STEEL,
	MODIFIER_BATON_UPGRADE,
	MODIFIER_STRESS_BALL,
	MODIFIER_RED_STAPLER,
	MODIFIER_WELLNESS_PROGRAM,
	MODIFIER_PERFORMANCE_REVIEW,
	MODIFIER_BACKUP_SERVER,
	MODIFIER_OVERCLOCKED_RIG,
	MODIFIER_CORNER_OFFICE,
	MODIFIER_POWER_SUIT,
	MODIFIER_ENERGY_DRINK,
	MODIFIER_OVERACHIEVER,
	MODIFIER_THICK_SKIN,
	MODIFIER_TOXIC_ATMOSPHERE,
	MODIFIER_IRON_CONSTITUTION,
	MODIFIER_EXTRA_SHIFT,
	MODIFIER_COMPANY_CAR,
	MODIFIER_SALES_MOTIVATION,
	MODIFIER_STEEL_TOE_BOOTS,
	MODIFIER_INDUSTRIAL_CLEANER,
	MODIFIER_THERMAL_MUG,
	MODIFIER_DOUBLE_ESPRESSO,
]

const ENEMY_BUMAGA: EnemyData = preload("res://resources/enemies/01_BumagaData.tres")
const ENEMY_PRINTER: EnemyData = preload("res://resources/enemies/02_PrinterData.tres")
const ENEMY_SHKAF: EnemyData = preload("res://resources/enemies/03_ShkafData.tres")
const ENEMY_NOZHNICI: EnemyData = preload("res://resources/enemies/04_NozhniciData.tres")
const ENEMY_KULER: EnemyData = preload("res://resources/enemies/05_KulerData.tres")
const ENEMY_PROECTOR: EnemyData = preload("res://resources/enemies/06_ProectorData.tres")
const ENEMY_FAX: EnemyData = preload("res://resources/enemies/07_FaxData.tres")
const ENEMY_SHREDER: EnemyData = preload("res://resources/enemies/08_ShrederData.tres")
const ENEMY_VIGOR_RAB: EnemyData = preload("res://resources/enemies/09_VigorRabData.tres")
const ENEMY_BOSS: EnemyData = preload("res://resources/enemies/10_BossData.tres")

## One entry per round; each entry lists every enemy to spawn that round.
const ROUND_ENEMIES: Array[Array] = [
	[ENEMY_BUMAGA],
	[ENEMY_PRINTER],
	[ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA],
	[ENEMY_PRINTER, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA],
	[ENEMY_SHKAF, ENEMY_BUMAGA, ENEMY_BUMAGA],
	[ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA],
	[ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_PRINTER, ENEMY_PRINTER],
	[ENEMY_NOZHNICI],
	[ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_NOZHNICI],
	[ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, 
		ENEMY_PRINTER, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_NOZHNICI],
	[ENEMY_KULER],
	[ENEMY_KULER, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_KULER],
	[ENEMY_KULER, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_KULER, ENEMY_NOZHNICI, ENEMY_NOZHNICI],
	[ENEMY_KULER, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_NOZHNICI, ENEMY_NOZHNICI],
	[ENEMY_PROECTOR],
	[ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER, 
		ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER, ENEMY_PRINTER],
	[ENEMY_PROECTOR, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_NOZHNICI, ENEMY_NOZHNICI],
	[ENEMY_FAX],
	[ENEMY_FAX, ENEMY_FAX],
	[ENEMY_FAX, ENEMY_FAX, ENEMY_PROECTOR, ENEMY_PROECTOR],
	[ENEMY_SHREDER],
	[ENEMY_SHREDER, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA],
	[ENEMY_SHREDER, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_SHKAF, ENEMY_SHKAF, 
		ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA, ENEMY_BUMAGA],
	[ENEMY_VIGOR_RAB],
	[ENEMY_VIGOR_RAB, ENEMY_VIGOR_RAB],
	[ENEMY_VIGOR_RAB, ENEMY_VIGOR_RAB, ENEMY_NOZHNICI, ENEMY_NOZHNICI],
	[ENEMY_VIGOR_RAB, ENEMY_VIGOR_RAB, ENEMY_VIGOR_RAB, ENEMY_VIGOR_RAB],
	[ENEMY_VIGOR_RAB, ENEMY_VIGOR_RAB, ENEMY_KULER, ENEMY_KULER, ENEMY_KULER, ENEMY_KULER, ENEMY_KULER, ENEMY_KULER, ENEMY_KULER, ENEMY_KULER],
	[ENEMY_BOSS],
	[ENEMY_BOSS, ENEMY_VIGOR_RAB, ENEMY_VIGOR_RAB]
]
