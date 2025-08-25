extends RigidBody2D


class_name Animal

enum State { Default, Dragged, Free }

const DELTA_MIN: Vector2 = Vector2(-60.0, 0)
const DELTA_MAX: Vector2 = Vector2(0, +60.0)
const IMPULSE_MULT: float = -20.0
const IMPULSE_MAX_LENGTH: float = sqrt(2 * 1200**2)
const ARROW_MIN_SCALE: float = 0.0
const ARROW_MAX_SCALE: float = 0.6

@onready var _sprite_arrow: Sprite2D = $SpriteArrow
@onready var _player_stretch: AudioStreamPlayer = $PlayerStretch
@onready var _player_catapult: AudioStreamPlayer2D = $PlayerCatapult
@onready var _player_kick: AudioStreamPlayer2D = $PlayerKick

var _center: Vector2
var _touch_point: Vector2

var _diff: Vector2 = Vector2.ZERO
var _state: State = State.Default


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	freeze = true
	_center = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if _state == State.Dragged:
		_process_drag_state()


func _unhandled_input(event: InputEvent) -> void:
	if (
		_state == State.Dragged and 
		event.is_action_released("touch")
	):
		_change_state()


func _change_state() -> void:
	match _state:
		State.Default:
			_state = State.Dragged
			_set_dragged()
		State.Dragged:
			_state = State.Free
			call_deferred("_set_free")
			

func _set_dragged() -> void:
	_sprite_arrow.show()
	_touch_point = get_global_mouse_position()


func _set_free() -> void:
	SignalHub.emit_attempt_made()
	_sprite_arrow.hide()
	freeze = false
	apply_central_impulse(_calculate_impulse())
	_player_catapult.position = _touch_point + _diff
	_player_catapult.play()


func _process_drag_state() -> void:
	var current_diff: Vector2 = _calculate_diff()
	_play_drag_sound(current_diff)
	_diff = current_diff
	position = _center + _diff
	_transform_arrow()


func _calculate_diff() -> Vector2:
	var diff = get_global_mouse_position() - _touch_point
	return diff.clamp(DELTA_MIN, DELTA_MAX)


func _play_drag_sound(current_diff: Vector2) -> void:
	var discrepancy: Vector2 = current_diff - _diff
	if (
		discrepancy.length() > 0.1 and 
		not _player_stretch.playing
	):
		_player_stretch.play()


func _transform_arrow() -> void:
	var impulse: Vector2 = _calculate_impulse()
	_sprite_arrow.rotation = impulse.angle()
	var lerp_weight: float = clampf(
		impulse.length() / IMPULSE_MAX_LENGTH,
		0.0,
		1.0
	)
	var arrow_scale: float = lerp(
		ARROW_MIN_SCALE,
		ARROW_MAX_SCALE,
		lerp_weight
	)
	_sprite_arrow.scale.x = arrow_scale
	_sprite_arrow.scale.y = arrow_scale


func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if (
		_state == State.Default and 
		event.is_action_pressed("touch")
	):
		_change_state()


func _calculate_impulse() -> Vector2:
	return _diff * IMPULSE_MULT


func die() -> void:
	SignalHub.emit_animal_died()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()


func _on_sleeping_state_changed() -> void:
	if sleeping:
		var body: Node2D = get_colliding_bodies()[0]
		if body is Cup:
			die()
			body.die()


func _on_body_entered(body: Node) -> void:
	if (
		body is Cup and 
		not _player_kick.playing
	):
		_player_kick.play()
