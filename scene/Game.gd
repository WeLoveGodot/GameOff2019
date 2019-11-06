extends Node2D
# 游戏变量们先集中在这，有需求再搬家
var Planet = preload("res://scene/Planet.tscn")

# 真的操作镜头的缺点是如果需要改变近大远小的自然定律，你就要真的调整sprite的大小。
# 我们自己建模镜头的缩放，再根据此控制星球的位置和缩放，达到缩放镜头的效果
var camera_scale: float = 1.0

var planets = []

func add_planet(planet):
	planets.append(planet)
	# TODO: 更新镜头范围相关边界，比如最左点，最右点之类

func get_planets():
	return planets

func get_view_coor(coor: Vector2):
	return coor * camera_scale

func _ready():
	# test code
	for i in [1, 2, 3, 4]:
		var p = Planet.instance()
		p.set_coor(Vector2(i*200, i*200))
		$PlanetDrawer.add_child(p)
		add_planet(p)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
