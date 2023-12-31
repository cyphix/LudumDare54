extends Control



signal resume_game()



#===============================================================================
# Fields
#===============================================================================



#===============================================================================
# Node Methods
#===============================================================================
func _ready():
	hide()



#===============================================================================
# Methods
#===============================================================================



#===============================================================================
# Events
#===============================================================================
func _on_resume():
	resume_game.emit()

func _on_reset():
	get_tree().change_scene_to_file("res://scenes/workspace.tscn")

func _on_quit():
	get_tree().quit()
