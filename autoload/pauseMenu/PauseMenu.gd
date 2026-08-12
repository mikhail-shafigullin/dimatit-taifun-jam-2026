extends CanvasLayer

const MAIN_MENU_SCENE_PATH = "res://levels/mainMenu/MainMenu.tscn"

@onready var mainPanel: VBoxContainer = %MainPanel
@onready var settingsPanel: VBoxContainer = %SettingsPanel
@onready var resumeButton: Button = %ResumeButton
@onready var settingsButton: Button = %SettingsButton
@onready var backButton: Button = %BackButton
@onready var volumeSlider: HSlider = %VolumeSlider

var _isOpen: bool = false

func _ready() -> void:
	visible = false
	resumeButton.pressed.connect(_onResumePressed)
	settingsButton.pressed.connect(_onSettingsPressed)
	backButton.pressed.connect(_onBackPressed)
	volumeSlider.value_changed.connect(_onVolumeChanged)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	if not _isOpen and _isCurrentSceneMainMenu():
		return
	if _isOpen:
		_close()
	else:
		_open()
	get_viewport().set_input_as_handled()

func _isCurrentSceneMainMenu() -> bool:
	var currentScene := get_tree().current_scene
	return currentScene != null and currentScene.scene_file_path == MAIN_MENU_SCENE_PATH

func _open() -> void:
	_isOpen = true
	mainPanel.visible = true
	settingsPanel.visible = false
	volumeSlider.value = VolumeSettings.getSavedVolume()
	visible = true
	get_tree().paused = true

func _close() -> void:
	_isOpen = false
	visible = false
	get_tree().paused = false

func _onResumePressed() -> void:
	_close()

func _onSettingsPressed() -> void:
	mainPanel.visible = false
	settingsPanel.visible = true

func _onBackPressed() -> void:
	settingsPanel.visible = false
	mainPanel.visible = true

func _onVolumeChanged(value: float) -> void:
	VolumeSettings.applyVolume(value)
	VolumeSettings.saveVolume(value)
