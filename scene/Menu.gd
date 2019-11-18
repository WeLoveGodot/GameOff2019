extends CanvasLayer

signal start_game
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var arrow = load("res://resource/art/arrow.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(arrow)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://scene/Game.tscn")


func _on_AboutMenu_pressed():
	$WindowDialog.show()


func _on_CloseButton_pressed():
	get_tree().quit()
