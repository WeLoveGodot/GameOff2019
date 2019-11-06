extends Node2D

# 真的操作镜头的缺点是如果需要改变近大远小的自然定律，你就要真的调整sprite的大小。
# 我们自己建模镜头的缩放，再根据此控制星球的位置和缩放，达到缩放镜头的效果
var camera_scale: float = 1
const SIZE = 4096

func get_view_coor(coor: Vector2):
	return coor * camera_scale

func _ready():
	# test code
	$Plantes.debug()
	# test tween
	var t = $Tween
	t.interpolate_property(self, "camera_scale",
		1, 0.3, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	t.start()

# 根据玩家自己所有的所有星球，更新摄像机
func update_camera_scale(my_planets):
	# for p in my_planets:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
