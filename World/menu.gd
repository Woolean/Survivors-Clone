extends Control

var level = "res://World/world.tscn"

func _on_button_play_click_end() -> void:
	var _level = get_tree().change_scene_to_file(level)

func _on_button_exit_click_end() -> void:
	get_tree().quit()
