extends Control

const GAME_SCENE_PATH = "res://levels/GameScene.tscn"
const LOCALES = ["en", "ru"]

@onready var mainPanel: VBoxContainer = %MainPanel
@onready var settingsPanel: VBoxContainer = %SettingsPanel
@onready var startButton: Button = %StartButton
@onready var settingsButton: Button = %SettingsButton
@onready var backButton: Button = %BackButton
@onready var volumeSlider: HSlider = %VolumeSlider
@onready var languageOptionButton: OptionButton = %LanguageOptionButton

func _ready() -> void:
	startButton.pressed.connect(_onStartPressed)
	settingsButton.pressed.connect(_onSettingsPressed)
	backButton.pressed.connect(_onBackPressed)
	volumeSlider.value_changed.connect(_onVolumeChanged)
	languageOptionButton.item_selected.connect(_onLanguageSelected)

	var volume := VolumeSettings.getSavedVolume()
	volumeSlider.value = volume
	VolumeSettings.applyVolume(volume)

	var locale := LocalizationSettings.getSavedLocale()
	LocalizationSettings.applyLocale(locale)
	languageOptionButton.select(LOCALES.find(locale))

func _onStartPressed() -> void:
	SceneTransitionManager.transitionToScene(GAME_SCENE_PATH)

func _onSettingsPressed() -> void:
	mainPanel.visible = false
	settingsPanel.visible = true

func _onBackPressed() -> void:
	settingsPanel.visible = false
	mainPanel.visible = true

func _onVolumeChanged(value: float) -> void:
	VolumeSettings.applyVolume(value)
	VolumeSettings.saveVolume(value)

func _onLanguageSelected(index: int) -> void:
	var locale: String = LOCALES[index]
	LocalizationSettings.applyLocale(locale)
	LocalizationSettings.saveLocale(locale)
