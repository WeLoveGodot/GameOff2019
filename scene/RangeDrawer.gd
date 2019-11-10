extends Node2D

# 这个节点从game中获取所有有视野的单位，根据其范围绘制圆圈
# 优化相关：最好读一下屏幕范围，不要画全宇宙的圈圈
func _ready():
	pass # Replace with function body.

var r = 0
func update_field_r(new_r):
	r = new_r


func _process(delta):
	update()

func _draw():
	draw_circle(Vector2(0, 0), r, Color.red)