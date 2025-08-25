extends Control


const MAIN: PackedScene = preload(
	"res://scenes/main/main.tscn"
)

@onready var _vbox_container_middle: VBoxContainer = (
	$MarginContainer/VBoxContainerMiddle
)
@onready var _label_level: Label = (
	$MarginContainer/VBoxContainerTop/LabelLevel
)
@onready var _label_attempts: Label = (
	$MarginContainer/VBoxContainerTop/LabelAttempts
)
@onready var _audio_stream_player: AudioStreamPlayer = (
	$AudioStreamPlayer
)

var _attempts: int = 0


func _enter_tree() -> void:
	SignalHub.attempt_made.connect(_on_attempt_made)
	SignalHub.level_completed.connect(_on_level_completed)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_vbox_container_middle.hide()
	_label_level.text = "Level: %d" % DataManager.level
	_set_attempts_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	var to_escape: bool = (
		event.is_action_pressed("escape") or 
		(
			_vbox_container_middle.visible and 
			event.is_action_pressed("back_to_menu")
		)
	)
	if to_escape:
		get_tree().change_scene_to_packed(MAIN)


func _on_level_completed() -> void:
	DataManager.records.update_record(
		DataManager.level,
		_attempts
	)
	DataManager.save_records()
	_vbox_container_middle.show()
	_audio_stream_player.play()


func _on_attempt_made():
	_attempts += 1
	_set_attempts_text()


func _set_attempts_text():
	_label_attempts.text = "Attempts: %d" % _attempts
