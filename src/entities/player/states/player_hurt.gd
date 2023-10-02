class_name PlayerHurtState
extends State



#===============================================================================
# Fields
#===============================================================================
var direction: Vector2
var knockback_force: float = 400
var frames: int = 3



#===============================================================================
# Internal Fields
#===============================================================================
var _timer: int = 0



#===============================================================================
# Methods
#===============================================================================
func enter():
	super.enter()
	
	play_animation.emit(self._state_name)
	
	set_velocity.emit(direction * knockback_force, true, true)
	_timer = 0

func exit():
	super.exit()

func phyx_update(delta, is_on_floor: bool):
	super.phyx_update(delta, is_on_floor)
	
	_timer += 1

func knockback(knock_direction: Vector2):
	set_velocity.emit(knock_direction * knockback_force, true, true)



#===============================================================================
# Internal Methods
#===============================================================================
func _initialize():
	self._state_name = "hurt"

func _phyx_transition_check(is_on_floor: bool):
	if _timer >= frames:
		if !is_on_floor:
			transition_state.emit("fall")
			return
		else:
			transition_state.emit("idle")
			return
