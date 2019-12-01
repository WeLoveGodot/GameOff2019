extends Node2D

signal show_about

var full_screen_button = null

func _ready():
	full_screen_button = get_node("VBoxContainer/FullScreenButton")

func _on_FullScreenButton_pressed():
	if OS.is_window_fullscreen():
		OS.set_window_fullscreen(false)
		full_screen_button.set_normal_texture(load("res://resource/art/UI/FullScreenButton_Normal.png"))
		full_screen_button.set_pressed_texture(load("res://resource/art/UI/FullScreenButton_Pressed.png"))
		full_screen_button.set_hover_texture(load("res://resource/art/UI/FullScreenButton_Hover.png"))
	else:
		full_screen_button.set_normal_texture(load("res://resource/art/UI/WindowedButton_Normal.png"))
		full_screen_button.set_pressed_texture(load("res://resource/art/UI/WindowedButton_Pressed.png"))
		full_screen_button.set_hover_texture(load("res://resource/art/UI/WindowedButton_Hover.png"))
		OS.set_window_fullscreen(true)

func _on_HelpButton_pressed():
	pass 

func _on_CloseButton_pressed():
	get_tree().quit()


func _on_AboutButton_pressed():
	emit_signal("show_about")
