class_name GameManager
extends Node



#===============================================================================
# Fields
#===============================================================================
#== Cached References
@onready var _game_over_menu: Control = $GUICanvas/GameOver
@onready var _win_menu: Control = $GUICanvas/Win
@onready var _pause_menu: Control = $GUICanvas/Pause
@onready var hearts_container: HeartContainer = $GUICanvas/HealthContainer
@onready var player: Player = $Level/Player
@onready var player_animator: AnimationPlayer = $Level/Player/AnimationPlayer
@onready var _water: Water = $Level/Water



#===============================================================================
# Internal Fields
#===============================================================================
var _paused: bool = false
var _game_over = false

var _players: Array[Player] = []



#===============================================================================
# Node Methods
#===============================================================================
func _ready():
	if hearts_container != null and player != null:
		hearts_container.set_max_hearts(player.max_health)
		hearts_container.set_current_health(player.get_health())
		player.update_health.connect(hearts_container.on_health_change)
	else:
		push_error("Heart Container or Player null")
	
	_pause_game(false)

func _process(delta):
	if !_game_over:
		if Input.is_action_pressed("pause"):
			if !_paused:
				_paused = true
				_pause_menu.show()
				_pause_game(true)
				set_physics_process(false)



#===============================================================================
# Methods
#===============================================================================
func register_player(reg_player: Player):
	_players.append(reg_player)
	
	if !reg_player.died.is_connected(_on_player_death):
		reg_player.died.connect(_on_player_death)



#===============================================================================
# Internal Methods
#===============================================================================
func _pause_game(status: bool):
	get_tree().paused = status
	set_physics_process(!status)
	_paused = status



#===============================================================================
# Events
#===============================================================================
func _on_player_death():
	_game_over = true
	_game_over_menu.show()
	await player_animator.animation_finished
	_pause_game(true)

func _on_player_win():
	_game_over = true
	_water.stop(500)
	_win_menu.show()

func _on_resume():
	_pause_game(false)
	_pause_menu.hide()
