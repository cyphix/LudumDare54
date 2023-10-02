class_name Water
extends Node2D



@export var rise_rate: float = 10
@export var rise: bool = true

var _stop_frames: int = 0



func _process(delta):
	if !rise and _stop_frames <= 0:
		return
	
	if !rise and _stop_frames > 0:
		_stop_frames -= 1
	
	position.y += -rise_rate * delta


func stop(frames: int):
	rise = false
	_stop_frames = frames
