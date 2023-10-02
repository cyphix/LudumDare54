class_name PlayerJumpState
extends State



#===============================================================================
# Fields
#===============================================================================
var _horizontal_speed: float
var _jump_velocity: float
var _min_frames: int
var _max_frames: int

var _frames_active: int = 0



#===============================================================================
# Methods
#===============================================================================
func set_variables(horizontal_speed: float, jump_velocity: float, min_jump: int = 3, max_jump: int = 10):
	_horizontal_speed = horizontal_speed
	_jump_velocity = jump_velocity
	_min_frames = min_jump
	_max_frames = max_jump



func enter():
	super.enter()
	
	_frames_active = 0
	
	play_animation.emit(self._state_name)
	
	# Since the first phyx step is skipped, force it
	phyx_update(0, false)

func exit():
	super.exit()

func phyx_update(delta, is_on_floor: bool):
	super.phyx_update(delta, is_on_floor)
	if !_active:
		return
	
	_has_jump_end()
	
	# Handle Jump.
	var direction = Input.get_axis("player_move_left", "player_move_right")
	set_velocity.emit(Vector2(direction * _horizontal_speed, _jump_velocity), true, true)
	
	_frames_active += 1



#===============================================================================
# Internal Methods
#===============================================================================
func _initialize():
	self._state_name = "jump"

func _has_jump_end():
	# If max hit end without checking input
	if _frames_active >= _max_frames:
		return true
		
	if Input.is_action_just_released("player_jump"):
		if _frames_active >= _min_frames:
			# For snappy jump, reduce the Y velocity
			set_velocity.emit(Vector2(0, _jump_velocity/2), false, true)
			return true
	
	return false

func _phyx_transition_check(is_on_floor: bool):
	# First check that the player's world state has not changed
	if _has_jump_end():
		transition_state.emit("fall")
		return
