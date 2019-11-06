extends Node2D

# 真的操作镜头的缺点是如果需要改变近大远小的自然定律，你就要真的调整sprite的大小。
# 我们自己建模镜头的缩放，再根据此控制星球的位置和缩放，达到缩放镜头的效果
var camera_scale: float = 1.0

func get_view_coor(coor: Vector2):
	return coor * camera_scale

func _ready():
	# test code
	$Plantes.debug()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
