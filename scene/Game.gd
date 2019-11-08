extends Node2D

# 真的操作镜头的缺点是如果需要改变近大远小的自然定律，你就要真的调整sprite的大小。
# 我们自己建模镜头的缩放，再根据此控制星球的位置和缩放，达到缩放镜头的效果
var camera_scale: float = 2
const SIZE = 4096
# 星球生成概率
const PLANTE_GEN_PROB = 0.0003
# 星球生成上限
const MAX_PLANETS = 2000

func get_view_coor(coor: Vector2):
	return coor * camera_scale

func _ready():
	# test code
	init_planets()
	# test_tween()

func test_tween():
	var t = $Tween
	t.interpolate_property(self, "camera_scale",
		2, 0.4, 0.3,
		Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	t.start()


func init_planets():
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	var half_size = SIZE / 2
	for row in range(0, SIZE, 5):
		for col in range(0, SIZE, 5):
			var x = noise.get_noise_2d(row, col)
			if abs(x) < PLANTE_GEN_PROB && $Planets.len() < MAX_PLANETS:
				$Planets.new_planet(Vector2(row - half_size, col - half_size))


# 根据玩家自己所有的所有星球，更新摄像机
func update_camera_scale(my_planets):
	# for p in my_planets:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
