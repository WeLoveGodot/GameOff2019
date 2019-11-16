extends Node2D

var me

# debug相机的话，就不自动scale，由人来控制
var is_debug_camera: bool = false

func _ready():
  # test code
  # init_camera()
  init_planets()
  add_me()
  assert(me != null)
  # test_tween()

func test_tween():
  var t = $Tween
  t.interpolate_property(me, "field_radius", 50, 1000, 1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
  t.start()

func init_camera():
  $Camera.zoom = Vector2(1, 1)

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
	print("got me", me.position, me.field_radius)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if !is_debug_camera:
    update_camera_zoom()
  draw_holes()

func draw_holes():
	collect_holes()
	$Holes.draw_holes()

func collect_holes():
	$Holes.clear_holes()
	$Holes.add_hole(me.field_radius, me.get_coor())
	$Holes.add_hole(me.field_radius, Vector2(50,50))

func update_camera_zoom():
  var half_height = Global.EXRA_CAMERA_HEIGHT + Global.explore_distance(me)
  # zoom==1 -> Global.WINDOW_SIZE.y
  var zoom = half_height * 2 / Global.WINDOW_SIZE.y
  $Camera.zoom = Vector2(zoom, zoom)

func _on_DebugMenu_debug_camera(is_debug):
  is_debug_camera = is_debug
  print(is_debug_camera)


func _on_DebugMenu_new_camera_scale(is_up):
  if is_debug_camera:
    print("scale", is_up)
    if is_up:
      $Camera.zoom /= 1.2
    else:
      $Camera.zoom *= 1.2
    print($Camera.zoom)
