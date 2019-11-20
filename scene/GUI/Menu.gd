extends CanvasLayer

signal start_game

var arrow = load("res://resource/art/arrow.png")

func _ready():
	Input.set_custom_mouse_cursor(arrow)

func _on_StartButton_pressed():
	get_tree().change_scene("res://scene/Game.tscn")


func _on_HelpButton_pressed():
	pass # Replace with function body.
