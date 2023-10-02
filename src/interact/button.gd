class_name DoorButton
extends Area2D



signal open_door()



#===============================================================================
# Inspector Fields
#===============================================================================



#===============================================================================
# Fields
#===============================================================================
@onready var _sprite: Sprite2D = get_node("Sprite2D")

var _button_activated: bool = false
var _anim_finished: bool = false
var _anim_time: float = 1



#===============================================================================
# Node Methods
#===============================================================================
func _ready():
	if !body_entered.is_connected(_on_enter):
			body_entered.connect(_on_enter)
	if !body_exited.is_connected(_on_exit):
			body_exited.connect(_on_exit)

func _process(delta):
	if _button_activated and _anim_time > 0:
		_sprite.frame = 1
		_anim_time -= delta
	
	if !_anim_finished and _anim_time <= 0:
		_sprite.frame = 2
		_anim_finished = true



#===============================================================================
# Methods
#===============================================================================
func activate_button():
	_button_activated = true
	
	open_door.emit()



#===============================================================================
# Internal Methods
#===============================================================================



#===============================================================================
# Events
#===============================================================================
func _on_enter(body):
	if body is Player:
		(body as Player).button_zone(true, self)

func _on_exit(body):
	if body is Player:
		(body as Player).button_zone(false)
