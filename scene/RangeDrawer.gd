extends ColorRect

var mat
func _ready():
	mat = self.get_material()

func update_field_r(new_r):
	mat.set_shader_param("R", float(new_r) / Global.SIZE)


func _process(delta):
	update()