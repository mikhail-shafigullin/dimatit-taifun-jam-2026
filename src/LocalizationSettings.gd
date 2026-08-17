class_name LocalizationSettings
extends RefCounted

const DEFAULT_LOCALE = "en"

static func getSavedLocale() -> String:
	var saveData := SaveSystem.load()
	var settings: Dictionary = saveData.get("settings", {})
	return settings.get("locale", DEFAULT_LOCALE)

static func applyLocale(locale: String) -> void:
	TranslationServer.set_locale(locale)

static func saveLocale(locale: String) -> void:
	var saveData := SaveSystem.load()
	var settings: Dictionary = saveData.get("settings", {})
	settings["locale"] = locale
	saveData["settings"] = settings
	SaveSystem.save(saveData)
