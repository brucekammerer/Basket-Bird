extends Node


const RECORDS_PATH: String = "records.tres"
const RECORDS_TYPE: String = "Records"

var records: Records


func _ready() -> void:
    load_records()


var level: int = 0:
    get:
        return level
    set(value):
        level = value


func load_records() -> void:
    if ResourceLoader.exists(RECORDS_PATH, RECORDS_TYPE):
        records = ResourceLoader.load(RECORDS_PATH, RECORDS_TYPE)
        if records == null:
            records = Records.new()
    else:
        records = Records.new()


func save_records() -> void:
    ResourceSaver.save(records, RECORDS_PATH)