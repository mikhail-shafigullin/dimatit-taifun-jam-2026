extends Control

const GAME_SCENE_PATH = "res://levels/debug/Level2D.tscn"

@onready var mainPanel: VBoxContainer = %MainPanel
@onready var settingsPanel: VBoxContainer = %SettingsPanel
@onready var startButton: Button = %StartButton
@onready var settingsButton: Button = %SettingsButton
@onready var backButton: Button = %BackButton
@onready var volumeSlider: HSlider = %VolumeSlider

func _ready() -> void:
	startButton.pressed.connect(_onStartPressed)
	settingsButton.pressed.connect(_onSettingsPressed)
	backButton.pressed.connect(_onBackPressed)
	volumeSlider.value_changed.connect(_onVolumeChanged)

	var volume := VolumeSettings.getSavedVolume()
	volumeSlider.value = volume
	VolumeSettings.applyVolume(volume)

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
