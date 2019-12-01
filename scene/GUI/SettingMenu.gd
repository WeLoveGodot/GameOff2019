extends Node2D

var full_screen_button = null

onready var full_screen_labal = get_node("VBoxContainer/FullScreenButton/Label")

func _ready():
	pass

func set_is_in_game():
	get_node("VBoxContainer/RetryButton").visible = true
	get_node("VBoxContainer/MenuButton").visible = true

func _on_FullScreenButton_pressed():
	if OS.is_window_fullscreen():
		OS.set_window_fullscreen(false)
		full_screen_labal.set_text("FULL SCREEN")
	else:
		OS.set_window_fullscreen(true)
		full_screen_labal.set_text("WINDOWED")
func _on_CloseButton_pressed():
	get_tree().quit()


func _on_AboutButton_pressed():
		var _about_ui = load("res://scene/GUI/About.tscn").instance()
		get_tree().get_root().add_child(_about_ui)

func _on_HelpButton_pressed():
		var _tutorial_ui = load("res://scene/GUI/Tutorial.tscn").instance()
		get_tree().get_root().add_child(_tutorial_ui)

func _on_MenuButton_pressed():
	get_tree().change_scene("res://scene/GUI/Menu.tscn")


func _on_RetryButton_pressed():
	get_tree().reload_current_scene()
