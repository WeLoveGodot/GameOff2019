extends Node2D

var me

# debug相机的话，就不自动scale，由人来控制
var is_debug_camera: bool = false
var debug = 1.0

var _gui

var _loading

var _zoom_limit = Global.SIZE / Global.WINDOW_SIZE.y

func _ready():
  _init_camera()
  # _gui = load("res://scene/GUI/MainGUI.tscn").instance()
  # add_child(_gui)
  _loading = load("res://scene/Loading.tscn").instance()
  _loading.setup(self)
  add_child(_loading)
  _loading.start_async_loading()

func _process(delta):
  if _loading.is_loading():
    _loading.loading_tick(delta)
  else:
    _game_tick(delta)

func test_tween():
  var t = $Tween
  t.interpolate_property(self, "debug", 1.0, 0.0, 2, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
  t.start()

func add_planet(noise, row, col, half_size):
  var x = noise.get_noise_2d(row, col)
  # Log.log("info", "try planet at %s %s | %s" % [row, col, x])
  if abs(x) < Global.PLANTE_GEN_PROB:# && $Planets.len() < Global.MAX_PLANETS:
    var coor = Vector2(row - half_size, col - half_size)
    var p = $Planets.new_planet(coor)
    # Log.log("info", "add planet to %s %s" % [row, col])
    eat_resource(p)
    return true
  return false

func add_resource(noise, row, col, half_size):
  var x = noise.get_noise_2d(row, col)
  if abs(x) < Global.RESOURCE_GEN_PROB:
    var coor = Vector2(row - half_size, col - half_size)
    $Resources.add_resource(coor)
    return true
  return false

func add_me():
  me = $Planets.new_planet(Vector2(0, 0))
  me.is_me = true
  eat_resource(me)

## skills
func add_explore(config):
  $Explores.add_explore(config)

func add_attack(config):
  $Attacks.add_attack(config)

func _game_tick(delta):
  if !is_debug_camera:
    update_camera_zoom()
  $Planets.update_planets(delta)
  draw_holes()
  var now = OS.get_ticks_msec()

func draw_holes():
  collect_holes()
  $Holes.draw_holes()

func collect_holes():
  $Holes.clear_holes()
  $Holes.add_hole(me.field_radius, me.get_coor())
  for node in $Explores.get_children():
    if node.config.is_me:
      $Holes.add_hole(node.config.r, node.get_position())
  for node in $Attacks.get_children():
    if node.config.is_me:
      $Holes.add_hole(node.r, node.get_position())

func _init_camera():
  # _zoom_limit = Global.SIZE / 2 / Global.WINDOW_SIZE.y
  $Camera.zoom = Vector2(1, 1)

func update_camera_zoom():
  var half_height = Global.explore_radius(me) + Global.explore_distance(me)
  # zoom==1 -> Global.WINDOW_SIZE.y
  var zoom = min(half_height * 2 / Global.WINDOW_SIZE.y, _zoom_limit)
  $Camera.zoom = Vector2(zoom, zoom)

func eat_resource(p):
  var got_energy: int = $Resources.eat_resource(
    p.position,
    p.field_radius
  )
  p.energy += got_energy

func _on_DebugMenu_debug_camera(is_debug):
  is_debug_camera = is_debug


func _on_DebugMenu_new_camera_scale(is_up):
  if is_debug_camera:
    if is_up:
      $Camera.zoom /= 1.2
    else:
      $Camera.zoom *= 1.2

func on_destroy_planets(pos, r, level):
  var planets = $Planets.get_planets_in_range(pos, r)
  for p in planets:
    if p.level <= level:
      p.destroy()