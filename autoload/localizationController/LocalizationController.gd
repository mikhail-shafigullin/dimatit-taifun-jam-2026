extends Node

func _ready() -> void:
	_registerTranslations()
	LocalizationSettings.applyLocale(LocalizationSettings.getSavedLocale())

func _registerTranslations() -> void:
	var ru := Translation.new()
	ru.locale = "ru"
	for key in Translations.RU:
		ru.add_message(key, Translations.RU[key])
	TranslationServer.add_translation(ru)
