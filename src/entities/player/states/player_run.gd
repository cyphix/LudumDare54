class_name PlayerRunState
extends State



#===============================================================================
# Fields
#===============================================================================
var speed: float



#===============================================================================
# Methods
#===============================================================================
func enter():
	super.enter()
	
	play_animation.emit(self._state_name)
	
	# Since the first phyx step is skipped, force it
	phyx_update(0, true)

func exit():
	super.exit()

func phyx_update(delta, is_on_floor: bool):
	super.phyx_update(delta, is_on_floor)
	if !_active:
		return
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("player_move_left", "player_move_right")
	if direction:
		set_velocity.emit(Vector2(direction * speed, 0), true, false)



#===============================================================================
# Internal Methods
#===============================================================================
func _initialize():
	self._state_name = "run"

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
	if !Input.get_axis("player_move_left", "player_move_right"):
		transition_state.emit("idle")
		return
