extends TextureButton


@export var level: int = 0

var SCALE_DEFAULT: Vector2 = Vector2(1.0, 1.0)
var SCALE_INCREASED: Vector2 = Vector2(1.1, 1.1)

@onready var _label_level: Label = (
	$MarginContainer/VBoxContainer/LabelLevel
)
@onready var _label_attempts: Label = (
	$MarginContainer/VBoxContainer/LabelAttempts
)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_label_level.text = "%d" % level
	_label_attempts.text = "%d" % DataManager.records.get_record(level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	DataManager.level = level
	get_tree().change_scene_to_file(
		"res://scenes/base_level/level%d.tscn" % level
	)


func _on_mouse_entered() -> void:
	scale = SCALE_INCREASED


func _on_mouse_exited() -> void:
	scale = SCALE_DEFAULT
