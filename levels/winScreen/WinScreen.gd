extends Control

const MAIN_MENU_SCENE_PATH = "res://levels/mainMenu/MainMenu.tscn"

const WIN_TEXT = "You win!\nThank you for playing!"
const LOSE_TEXT = "You lose!\nThank you for playing!"

@onready var winLabel: Label = %WinLabel
@onready var menuButton: Button = %MenuButton

func _ready() -> void:
	menuButton.pressed.connect(_onMenuPressed)
	winLabel.text = WIN_TEXT if Global.lastGameOutcome == Global.GameOutcome.WIN else LOSE_TEXT

func _onMenuPressed() -> void:
	SceneTransitionManager.transitionToScene(MAIN_MENU_SCENE_PATH)
