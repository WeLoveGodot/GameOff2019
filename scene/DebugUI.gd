extends Control
signal debug_camera(is_debug)
signal new_camera_scale(is_up)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	# print(event.type)
	# if event.type == InputEvent.MOUSE_BUTTON:
	if event is InputEventMouseButton:
		# zoom in
		if event.button_index == BUTTON_WHEEL_UP:
			emit_signal("new_camera_scale", true)
		# zoom out
		if event.button_index == BUTTON_WHEEL_DOWN:
			emit_signal("new_camera_scale", false)


func _on_CheckBox_toggled(button_pressed):
	emit_signal("debug_camera", button_pressed)
