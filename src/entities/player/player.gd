class_name Player
extends CharacterBody2D



signal died()
signal update_health(health: int)



#===============================================================================
# Inspector Fields
#===============================================================================
@export_category("Player Data")
@export_group("Movement")
@export var _speed: float = 600
@export_subgroup("Jump")
#@export var _air_horizontal_speed: float = 600
@export var _jump_velocity: float = -400
@export var _min_jump: int = 3
@export var _max_jump: int = 10

@export_group("Health")
@export var health: int = 3
@export var max_health: int = 3
@export var knockback: float = 400
@export var knockback_duration: int = 3

@export_group("State Machine")
@export var _starting_state: State



#===============================================================================
# Fields
#===============================================================================
#=== Cached references
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite: Sprite2D = get_node("PlayerSprite")
@onready var animator: AnimationPlayer = get_node("AnimationPlayer")

#=== Member fields
var _alive: bool
var _immortal: bool = false
var _current_state: State
var _states = {}

var _door_button: DoorButton = null



#===============================================================================
# Node Methods
#===============================================================================
func _ready():
	_initialize()
	
	var root_node = get_tree().root.get_children()[0]
	if root_node is GameManager:
		(root_node as GameManager).register_player(self)
	else:
		push_warning("Root node for GameManager not found by [%s]" % self.name)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Make sure is still alive
	if !_alive:
		return
	
	# Check that the state machine actual has a current state
	if _current_state == null:
		return
	
	# Run the states physics
	_current_state.phyx_update(delta, is_on_floor())
	
	move_and_slide()
	
	
	
#===============================================================================
# Methods
#===============================================================================
func button_zone(entered: bool, button: DoorButton = null):
	if entered and button != null:
		_door_button = button
	else:
		_door_button = null

func get_health():
	return health

func hurt(damage: int, source_pos: Vector2):
	if _immortal:
		return
	
	if !(_current_state is PlayerHurtState):
		health -= damage
		update_health.emit(health)
		
		# knockback
		var direction = (global_position - source_pos).normalized()
		if _states.has("hurt"):
			(_states["hurt"] as PlayerHurtState).direction = direction
			_transition_state(_states["hurt"])
		
		if health < 1:
			_alive = false
			animator.play("death")
			died.emit()

func immortal(yes: bool):
	if yes:
		_immortal = true



#===============================================================================
# Internal Methods
#===============================================================================
func _flip_facing(direction: float):
	if direction > 0:
			sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

func _initialize():
	_alive = true
	_current_state = null
	
	if _starting_state == null:
		push_error("Player missing starting state!")
		return
	
	# Cache the states
	var states_node = get_node("States")
	if states_node == null:
		push_error("States Node is not implemented")
		return
	for child in states_node.get_children():
		if child is State:
			# Set the state in the dictionary
			_states[(child as State).get_state_name()] = child
			# Connect all the signals
			if !child.play_animation.is_connected(_on_play_animation):
				child.play_animation.connect(_on_play_animation)
			if !child.transition_state.is_connected(_on_transition):
				child.transition_state.connect(_on_transition)
			if !child.set_velocity.is_connected(_on_set_velocity):
				child.set_velocity.connect(_on_set_velocity)
		
	# Keep for testing
	#for state in _states:
		#print((_states[state] as State).get_state_name())
		
	for state in _states:
		if _states[state] is PlayerFallState:
			(_states[state] as PlayerFallState).horizontal_speed = _speed
		if _states[state] is PlayerHurtState:
			(_states[state] as PlayerHurtState).knockback_force = knockback
			(_states[state] as PlayerHurtState).frames = knockback_duration
		if _states[state] is PlayerJumpState:
			(_states[state] as PlayerJumpState).set_variables(
				_speed, _jump_velocity, _min_jump, _max_jump
			)
		if _states[state] is PlayerRunState:
			(_states[state] as PlayerRunState).speed = _speed
	
	_start_state_machine()



#===============================================================================
# Events
#===============================================================================
func _on_hit_button():
	if _door_button != null:
		_door_button.activate_button()

func _on_play_animation(animation: String):
	animator.play(animation)

func _on_transition(to_state: String):
	if _states.has(to_state):
		#print("Transitioning to [%s]" % to_state)
		_transition_state(_states[to_state] as State)

func _on_set_velocity(new_velocity: Vector2, use_x: bool, use_y: bool):
	#print("Set Velocity: [%s, %s, %s]" % [new_velocity, use_x, use_y])
	if use_x:
		_flip_facing(new_velocity.x)
		velocity.x = new_velocity.x
	if use_y:
		velocity.y = new_velocity.y
	
	#print("Velocity: %s" % velocity )



#===============================================================================
# State Machine Methods
#===============================================================================
func _start_state_machine():
	# Transition to the starting state if there is one
	if _starting_state != null:
		_transition_state(_starting_state)

func _transition_state(to_state: State):
	if to_state == null:
		return
		
	if _current_state != null:
		_current_state.exit()
	
	_current_state = to_state
	to_state.enter()
