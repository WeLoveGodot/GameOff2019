extends Node2D

var me

# debug相机的话，就不自动scale，由人来控制
var is_debug_camera: bool = false
var debug = 1.0

func _ready():
  # test code
  # init_camera()
  init_planets()
  init_resources()
  add_me()
  assert(me != null)
  # test_tween()

func test_tween():
  var t = $Tween
  t.interpolate_property(self, "debug", 1.0, 0.0, 2, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
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

func init_resources():
  var s = Global.GEN_SIZE
  var noise = make_noise()
  var half_size = s / 2
  for row in range(0, s, 5):
    for col in range(0, s, 5):
      var x = noise.get_noise_2d(row, col)
      if abs(x) < Global.RESOURCE_GEN_PROB:
        var coor = Vector2(row - half_size, col - half_size)
        $Resources.add_resource(coor)



func add_me():
  me = $Planets.new_planet(Vector2(0, 0))
  me.is_me = true
  eat_resource(me)
  print("got me", me.position, me.field_radius)

## skills
func add_explore(r, speed, start, target):
  $Explores.add_explore(r, speed, start, target)

func add_attack(field_r, attack_r, speed, start, target):
  $Attacks.add_attack(field_r, attack_r, speed, start, target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if !is_debug_camera:
    update_camera_zoom()
  draw_holes()
  var now = OS.get_ticks_msec()

func draw_holes():
  collect_holes()
  $Holes.draw_holes()

func collect_holes():
  $Holes.clear_holes()
  $Holes.add_hole(me.field_radius, me.get_coor())
  for node in $Explores.get_children():
    $Holes.add_hole(node.r, node.get_position())
  for node in $Attacks.get_children():
    $Holes.add_hole(float(node.r), node.get_position())

func update_camera_zoom():
  var half_height = Global.explore_radius(me) + Global.explore_distance(me)
  # zoom==1 -> Global.WINDOW_SIZE.y
  var zoom = half_height * 2 / Global.WINDOW_SIZE.y
  $Camera.zoom = Vector2(zoom, zoom)

func eat_resource(p):
  print("eat", p)
  var got_energy: int = $Resources.eat_resource(
    p.position,
    p.field_radius
  )
  p.energy += got_energy

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
