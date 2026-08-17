extends Node

const CROSSFADE_DURATION = 0.5
const AUDIBLE_DB = 0.0
const SILENT_DB = -60.0

enum Track { INTRO, VERSE }

@onready var introPlayer: AudioStreamPlayer = %IntroPlayer
@onready var versePlayer: AudioStreamPlayer = %VersePlayer

var _currentTrack: Track = Track.INTRO
var _crossfadeTween: Tween

func _ready() -> void:
	introPlayer.stream.loop = true
	versePlayer.stream.loop = true
	introPlayer.play()
	versePlayer.play()
	EventBus.unit_choice_phase_started.connect(_onIntroRequested)
	EventBus.modifier_choice_phase_started.connect(_onIntroRequested)
	EventBus.battle_phase_started.connect(_onVerseRequested)
	EventBus.game_won.connect(_onIntroRequested)
	EventBus.game_lost.connect(_onIntroRequested)

func _onIntroRequested() -> void:
	_crossfadeTo(Track.INTRO)

func _onVerseRequested() -> void:
	_crossfadeTo(Track.VERSE)

func _crossfadeTo(track: Track) -> void:
	if track == _currentTrack:
		return
	_currentTrack = track
	var fadeInPlayer := introPlayer if track == Track.INTRO else versePlayer
	var fadeOutPlayer := versePlayer if track == Track.INTRO else introPlayer
	if _crossfadeTween != null:
		_crossfadeTween.kill()
	_crossfadeTween = create_tween()
	_crossfadeTween.set_parallel(true)
	_crossfadeTween.tween_property(fadeInPlayer, "volume_db", AUDIBLE_DB, CROSSFADE_DURATION)
	_crossfadeTween.tween_property(fadeOutPlayer, "volume_db", SILENT_DB, CROSSFADE_DURATION)
