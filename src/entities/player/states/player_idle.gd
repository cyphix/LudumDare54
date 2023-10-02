class_name PlayerIdleState
extends State



#===============================================================================
# Fields
#===============================================================================



#===============================================================================
# Methods
#===============================================================================
func enter():
	super.enter()
	
	play_animation.emit(self._state_name)
	
	set_velocity.emit(Vector2.ZERO, true, false)

func exit():
	super.exit()

func phyx_update(delta, is_on_floor: bool):
	super.phyx_update(delta, is_on_floor)



#===============================================================================
# Internal Methods
#===============================================================================
func _initialize():
	self._state_name = "idle"

func _phyx_transition_check(is_on_floor: bool):
	# First check that the player's world state has not changed
	if !is_on_floor:
		transition_state.emit("fall")
		return
	
	# Check the input
	if Input.is_action_just_pressed("player_press"):
		transition_state.emit("press")
		return
	if Input.is_action_just_pressed("player_jump"):
		transition_state.emit("jump")
		return
	if Input.get_axis("player_move_left", "player_move_right"):
		transition_state.emit("run")
		return
