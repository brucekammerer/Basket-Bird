extends Node

signal animal_died
signal level_completed
signal attempt_made
signal cup_created
signal cup_deleted


func emit_animal_died() -> void:
    animal_died.emit()


func emit_level_completed() -> void:
    level_completed.emit()


func emit_attempt_made() -> void:
    attempt_made.emit()


func emit_cup_created() -> void:
    cup_created.emit()


func emit_cup_deleted() -> void:
    cup_deleted.emit()