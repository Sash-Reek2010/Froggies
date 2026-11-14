extends Node2D

func _process(delta):
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().change_scene_to_file("res://menu.tscn")
