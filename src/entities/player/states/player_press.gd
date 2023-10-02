class_name PlayerPressState
extends State



#===============================================================================
# Fields
#===============================================================================
# I know this is bad, IM OUT OF TIME!
@onready var animator = $"../../AnimationPlayer"



#===============================================================================
# Methods
#===============================================================================
func enter():
	super.enter()
	
	play_animation.emit(self._state_name)
	hit_button.emit()
	
	set_velocity.emit(Vector2.ZERO, true, false)

func exit():
	super.exit()

func phyx_update(delta, is_on_floor: bool):
	super.phyx_update(delta, is_on_floor)



#===============================================================================
# Internal Methods
#===============================================================================
func _initialize():
	self._state_name = "press"

func _phyx_transition_check(is_on_floor: bool):
	if animator.is_playing():
		return
	
	# First check that the player's world state has not changed
	if is_on_floor:
		transition_state.emit("idle")
		return
	else:
		transition_state.emit("fall")
		return
