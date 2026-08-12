class_name VolumeSettings
extends RefCounted

const MASTER_BUS_NAME = "Master"

static func getSavedVolume() -> float:
	var saveData := SaveSystem.load()
	var settings: Dictionary = saveData.get("settings", {})
	return settings.get("masterVolume", 1.0)

static func applyVolume(value: float) -> void:
	var busIndex := AudioServer.get_bus_index(MASTER_BUS_NAME)
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(value))

static func saveVolume(value: float) -> void:
	var saveData := SaveSystem.load()
	var settings: Dictionary = saveData.get("settings", {})
	settings["masterVolume"] = value
	saveData["settings"] = settings
	SaveSystem.save(saveData)
