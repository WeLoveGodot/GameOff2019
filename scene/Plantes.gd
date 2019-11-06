extends Node2D
# 游戏变量们先集中在这，有需求再搬家
var Planet = preload("res://scene/Planet.tscn")

var game
var up_left = Vector2(0, 0)
var bottom_right = Vector2(0, 0)

var planets = []

func add_planet(planet):
	planets.append(planet)
	add_child(planet)
	update_coner(planet)
	# TODO: 更新镜头范围相关边界，比如最左点，最右点之类

func get_planets():
	return planets

func update_coner(planet):
	up_left.x = min(up_left.x, planet.coor.x)
	up_left.y = min(up_left.y, planet.coor.y)
	bottom_right.x = max(bottom_right.x, planet.coor.x)
	bottom_right.y = max(bottom_right.y, planet.coor.y)

func debug():
	for i in range(-4, 4):
		var p = Planet.instance()
		p.set_coor(Vector2(i*200, i*200))
		add_planet(p)

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for planet in get_planets():
		var view_coor = game.get_view_coor(planet.get_coor())
		planet.position = view_coor
