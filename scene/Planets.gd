extends Node2D
# 游戏变量们先集中在这，有需求再搬家
var Planet = preload("res://scene/Planet.tscn")

var _game
var _ai
var _up_left = Vector2(0, 0)
var _bottom_right = Vector2(0, 0)

func new_planet(coor):
	var p = Planet.instance()
	p.set_coor(coor)
	_add_planet(p)
	return p

func len():
	return get_child_count()

func get_planets_in_range(pos, r):
	var ps = []
	for p in get_children():
		# var x = p.position.x
		# var y = p.position.y
		if pos.distance_to(p.position) < r:
			ps.append(p)
	return ps

func update_planets(delta):
	var ps = get_children()
	for p in ps:
		p.update_scale(_game.get_node("Camera").zoom)
	_ai.update(delta, ps)

func _add_planet(planet):
	Log.log("debug", "add planet %s" % planet.field_radius)
	add_child(planet)
	_update_coner(planet)
	# TODO: 更新镜头范围相关边界，比如最左点，最右点之类

func _update_coner(planet):
	_up_left.x = min(_up_left.x, planet.position.x)
	_up_left.y = min(_up_left.y, planet.position.y)
	_bottom_right.x = max(_bottom_right.x, planet.position.x)
	_bottom_right.y = max(_bottom_right.y, planet.position.y)

func _debug():
	for i in range(-4, 4):
		new_planet(Vector2(i*200, i*200))

func _ready():
	_game = get_parent()
	_ai = load("res://scene/AI.tscn").instance()
	_ai.setup(self, _game)
