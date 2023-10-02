class_name HeartContainer
extends Node



#===============================================================================
# Fields
#===============================================================================
#== Cached References
@onready var heart_gui_obj = preload("res://prefabs/ui/heart_gui.tscn")

var hearts = []



#===============================================================================
# Node Methods
#===============================================================================
func _ready():
	if !heart_gui_obj:
		push_error("HeartGUI was not loaded")



#===============================================================================
# Methods
#===============================================================================
func set_current_health(health: int):
	for index in range(hearts.size()):
		if index < health:
			(hearts[index] as HeartGUI).update(true)
		else:
			(hearts[index] as HeartGUI).update(false)

func set_max_hearts(num_hearts: int):
	for i in range(num_hearts):
		var heart: HeartGUI = heart_gui_obj.instantiate()
		add_child(heart)
		hearts.append(heart)



#===============================================================================
# Internal Methods
#===============================================================================



#===============================================================================
# Events
#===============================================================================
func on_health_change(health: int):
	set_current_health(health)
