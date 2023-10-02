class_name State
extends Node



signal hit_button()
signal play_animation(animation: String)
signal transition_state(to_state: String)
signal set_velocity(velocity: Vector2, use_x: bool, use_y: bool)



#===============================================================================
# Fields
#===============================================================================
var _active: bool = false
var _state_name: String



#===============================================================================
# Node Methods
#===============================================================================
func _ready():
	self._initialize()



#===============================================================================
# Methods
#===============================================================================
func get_state_name():
	return self._state_name


func enter():
	_active = true

func exit():
	_active = false

func phyx_update(delta, is_on_floor: bool):
	if _active:
		_phyx_transition_check(is_on_floor)

func update():
	_transition_check()



#===============================================================================
# Internal Methods
#===============================================================================
func _initialize():
	pass

func _phyx_transition_check(is_on_floor: bool):
	pass

func _transition_check():
	pass
