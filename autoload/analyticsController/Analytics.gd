extends Node

var gameAnalytics;

func _ready():
	if(Engine.has_singleton("GameAnalytics")):
		gameAnalytics = Engine.get_singleton("GameAnalytics")
		gameAnalytics.init(AnalyticsSecrets.GAME_KEY, AnalyticsSecrets.SECRET_KEY)
		gameAnalytics.setEnabledInfoLog(true);

func sendDebugRequest(number: int):
	var optArgs = {
		"eventNumber": number,
		"eventVar": self
	}
	gameAnalytics.addDesignEvent("my:design:event", optArgs)

func sendProgressionEvent(number: int):
	var optArgs = {
		"eventNumber": number
	}
	gameAnalytics.addProgressionEvent("start", "level" + str(number), "", "", optArgs)

func sendUnitDataAdd(unitData: UnitData):
	var optArgs = {
		"unitData": unitData.unitName
	}
	gameAnalytics.addDesignEvent("add:unit", optArgs)

func sendModifierDataAdd(modifierData: ModifierData):
	var optArgs = {
		"modifierData": modifierData.modifierName
	}
	gameAnalytics.addDesignEvent("add:modifier", optArgs)