extends Node2D

var me

func _ready():
	# test code
	init_camera()
	init_planets()
	add_me()
	assert(me != null)
	# test_tween()

func test_tween():
	var t = $Tween
	t.interpolate_property(me, "field_radius", 50, 1000, 1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	t.start()

func init_camera():
	$Camera.zoom = Vector2(0.2, 0.2)

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

func add_me():
		me = $Planets.new_planet(Vector2(0, 0))
		print("got me", me.position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_camera_zoom()
	# $RangeDrawer.update_field_r(1000)
	$RangeDrawer.update_field_r(me.field_radius)

# func _draw():

func update_camera_zoom():
	var half_height = Global.EXRA_CAMERA_HEIGHT + Global.explore_distance(me)
	# zoom==1 -> Global.WINDOW_SIZE.y
	var zoom = half_height * 2 / Global.WINDOW_SIZE.y
	$Camera.zoom = Vector2(zoom, zoom)