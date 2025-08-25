extends StaticBody2D


class_name Cup


const ANIM_NAME: String = "disappear"

@onready var _animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalHub.emit_cup_created()


func die() -> void:
	_animation_player.play(ANIM_NAME)
	

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == ANIM_NAME:
		queue_free()
		SignalHub.emit_cup_deleted()
		
