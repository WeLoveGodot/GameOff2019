extends Node2D

var me

func _ready():
	# test code
	init_camera()
	init_planets()
	test_tween()

func test_tween():
	var t = $Tween
	# $Camera.zoom = Vector2(20, 10)
	print("min scale = %s", Global.MIN_SCALE)

func init_camera():
	$Camera.zoom = Vector2(0.5, 0.5)
	$Camera.position = Vector2(Global.SIZE / 2, Global.SIZE / 2)

func make_noise():
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	return noise

func init_planets():
	var noise = make_noise()
	var half_size = Global.SIZE / 2
	for row in range(0, Global.SIZE, 5):
		for col in range(0, Global.SIZE, 5):
			var x = noise.get_noise_2d(row, col)
			if abs(x) < Global.PLANTE_GEN_PROB && $Planets.len() < Global.MAX_PLANETS:
				var coor = Vector2(row - half_size, col - half_size)
				var p = $Planets.new_planet(coor)
				maybe_set_my_base(p, coor)
	assert(me != null)	

const RANGE = 200
func maybe_set_my_base(planet, coor: Vector2):
	if me == null && abs(coor.x - Global.SIZE / 2) < RANGE && abs(coor.y - Global.SIZE / 2) < RANGE:
		me = planet
		print("got me", me.position)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
