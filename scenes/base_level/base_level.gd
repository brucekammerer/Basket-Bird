extends Node2D

const ANIMAL_SCENE: PackedScene = preload(
	"res://scenes/animal/animal.tscn"
)

@onready var _spawn_point: Marker2D = $SpawnPoint

var _cups_count: int = 0


func _enter_tree() -> void:
	SignalHub.animal_died.connect(func():
		await get_tree().create_timer(
			0.5, true, true
		).timeout
		_spawn_animal()
	)
	SignalHub.cup_created.connect(func():
		_cups_count += 1
	)
	SignalHub.cup_deleted.connect(func():
		_cups_count -= 1
		if _cups_count == 0:
			SignalHub.emit_level_completed()
	)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_animal()


func _spawn_animal() -> void:
	var animal = ANIMAL_SCENE.instantiate()
	animal.position = _spawn_point.position
	add_child(animal)