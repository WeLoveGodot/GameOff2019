extends Control
signal debug_camera(is_debug)
signal new_camera_scale(is_up)

var game

func _ready():
	game = get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game.me:
		$r.set_text("r: " + String(game.me.field_radius))
	pass

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


func _on_ExpdButton_pressed():
	game.get_node("Skill").use_skill(game.me, Global.ESkill.EXPD, null)


func _on_ExprButton_pressed():
	game.get_node("Skill").use_skill(
		game.me,
		Global.ESkill.EXPR,
		{
			pos = Vector2(500, 600)
		}
	)
