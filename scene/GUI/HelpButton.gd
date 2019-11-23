extends TextureButton

signal help_button_clicked

const ROTATE_DURATION = 3

var _rotate_tween = null

func _ready():
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")
	self.connect("pressed", self, "_on_mouse_pressed")
	_rotate_tween = Tween.new()
	add_child(_rotate_tween)
	
func _on_mouse_entered():
	if _rotate_tween.is_repeat() == false:
		_rotate_tween.interpolate_property(get_parent(), "rotation_degrees", get_parent().get_rotation_degrees(),\
		get_parent().get_rotation_degrees() + 360, ROTATE_DURATION,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		_rotate_tween.set_repeat(true)
		_rotate_tween.start()
	else:
		_rotate_tween.resume_all()
	
func _on_mouse_exited():
	_rotate_tween.stop_all()
	
func _on_mouse_pressed():
	emit_signal("help_button_clicked")