class_name PlayerFallState
extends State



#===============================================================================
# Fields
#===============================================================================
var horizontal_speed: float



#===============================================================================
# Methods
#===============================================================================
func enter():
	super.enter()
	
	play_animation.emit(self._state_name)

func exit():
	super.exit()

func phyx_update(delta, is_on_floor: bool):
	super.phyx_update(delta, is_on_floor)
	if !_active:
		return
	
	var direction = Input.get_axis("player_move_left", "player_move_right")
	set_velocity.emit(Vector2(direction * horizontal_speed, 0), true, false)



#===============================================================================
# Internal Methods
#===============================================================================
func _initialize():
	self._state_name = "fall"

func _phyx_transition_check(is_on_floor: bool):
	# First check that the player's world state has not changed
	if is_on_floor:
		if Input.get_axis("player_move_left", "player_move_right"):
			transition_state.emit("run")
			return
		else:
			transition_state.emit("idle")
			return
