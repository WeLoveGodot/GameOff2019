extends CanvasLayer

signal start_game

var arrow = load("res://resource/art/arrow.png")
var MENU_DURATION = 0.5
var MENU_LENGTH = Vector2(450.0, 0.0)

var setting_animator = null
var setting_menu = null
onready var is_setting_menu_open = false


func _ready():
	Input.set_custom_mouse_cursor(arrow)
	setting_animator = get_node("SettingMenu/Animator")
	setting_menu = get_node("SettingMenu")

func _on_StartButton_pressed():
	get_tree().change_scene("res://scene/Game.tscn")


func _on_HelpButton_help_button_clicked():
	if is_setting_menu_open == false:
		is_setting_menu_open = true
		print(setting_menu.get("position"))
		setting_animator.interpolate_property(setting_menu, "position",
									 setting_menu.get_position(), setting_menu.get_position() - MENU_LENGTH, \
									 MENU_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		setting_animator.start()
		print(setting_menu.get("position"))
	else:
		is_setting_menu_open = false
		setting_animator.interpolate_property(setting_menu, "position", 
									 setting_menu.get_position(), setting_menu.get_position() + MENU_LENGTH, \
									 MENU_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		setting_animator.start()

var _about_ui
func _on_SettingMenu_show_about():
	if _about_ui == null:
		_about_ui = load("res://scene/GUI/About.tscn").instance()
		add_child(_about_ui)
	else:
		_about_ui.visible = true