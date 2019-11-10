extends Node2D

var me

func _ready():
	# test code
	init_camera()
	init_planets()
	focus_me()
	# test_tween()

func test_tween():
	var t = $Tween
	# $Camera.zoom = Vector2(20, 10)
	t.interpolate_property($Camera, "zoom", $Camera.zoom, Vector2(10, 10), 1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	t.start()
	# print("min scale = %s", Global.MIN_SCALE)

func init_camera():
	$Camera.zoom = Vector2(0.5, 0.5)

func make_noise():
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	return noise

func init_planets():
	var s = Global.GEN_SIZE
	var noise = make_noise()
	var half_size = s / 2
	for row in range(0, s, 5):
		for col in range(0, s, 5):
			var x = noise.get_noise_2d(row, col)
			if abs(x) < Global.PLANTE_GEN_PROB && $Planets.len() < Global.MAX_PLANETS:
				var coor = Vector2(row - half_size, col - half_size)
				$Planets.new_planet(coor)
	add_me()
	assert(me != null)

func add_me():
		me = $Planets.new_planet(Vector2(0, 0))
		print("got me", me.position)

func focus_me():
	$Camera.position = me.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
