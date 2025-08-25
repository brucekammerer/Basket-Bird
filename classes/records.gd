extends Resource


class_name Records


const DEFAULT_RECORD: int = 1000


@export var map: Dictionary[int, int]


func update_record(level: int, attempts: int) -> void:
    var record: int = map.get(level, DEFAULT_RECORD)
    if attempts < record:
        map[level] = attempts


func get_record(level: int) -> int:
    return map.get(level, DEFAULT_RECORD)
