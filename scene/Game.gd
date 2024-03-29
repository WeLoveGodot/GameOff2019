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
  _init_bg()
  # _gui = load("res://scene/GUI/MainGUI.tscn").instance()
  # add_child(_gui)
  $bgm.play()
  _loading = load("res://scene/Loading.tscn").instance()
  _loading.setup(self)
  add_child(_loading)
  _loading.connect("loading_finished", self, "post_load")
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
    eat_resource(p, false)
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
  eat_resource(me, true)

## skills
func add_explore(config):
  $Explores.add_explore(config)

func add_attack(config):
  $Attacks.add_attack(config)


var _last_check_time = 0
func _game_tick(delta):
  if !is_debug_camera:
    update_camera_zoom()
  $Planets.update_planets(delta)
  draw_holes()
  _check_result()
  var now = OS.get_ticks_msec()
  if now - _last_check_time > Global.TIME_CHECK_INTERVAL:
    _check_time(now)

func _check_time(now):
  if now - game_start_time > Global.TIME_LIMIT:
    Global.to_result(Global.EResult.TIME_LIMIT_FAIL)

func _check_result():
  if me.level >= Global.MAX_LEVEL:
    Global.to_result(Global.EResult.TECH_WIN)
  if $Planets.get_child_count() == 1 && $Planets.get_children()[0].is_me:
    Global.to_result(Global.EResult.ATK_WIN)
  if me.tech <= 0:
    Global.to_result(Global.EResult.NO_TECH)
  if me.energy <= 0:
    Global.to_result(Global.EResult.NO_ENERGY)

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

func _init_bg():
  var bg = $ColorRect
  var big_x = Global.SIZE / Global.WINDOW_SIZE.y * Global.WINDOW_SIZE.x
  bg.rect_size = Vector2(big_x, Global.SIZE)
  bg.rect_position = - bg.rect_size / 2
  var l = $SideRectL
  var r = $SideRectR
  l.rect_size = Vector2((big_x - Global.SIZE) / 2, Global.SIZE)
  r.rect_size = Vector2((big_x - Global.SIZE) / 2, Global.SIZE)
  l.rect_position = Vector2(- big_x / 2, -bg.rect_size.y / 2)
  r.rect_position = Vector2(big_x / 2 - r.rect_size.x, -bg.rect_size.y / 2)
  l.color = Color(0, 0, 0)
  r.color = Color(0, 0, 0)

func update_camera_zoom():
  var half_height = Global.explore_radius(me) + Global.explore_distance(me)
  # zoom==1 -> Global.WINDOW_SIZE.y
  var zoom = min(half_height * 2 / Global.WINDOW_SIZE.y, _zoom_limit)
  $Camera.zoom = Vector2(zoom, zoom)

func eat_resource(p, is_delay_effect):
  var got_energy: int = $Resources.eat_resource(
    p,
    p.position,
    p.field_radius,
    is_delay_effect
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

func on_destroy_planets(pos, r, level, source):
  var planets = $Planets.get_planets_in_range(pos, r)
  for p in planets:
    if p.level <= level:
      if source != null && is_instance_valid(source) && source.get_meta("type") == Global.ETag.P:
        source.energy += p.energy
        if source.is_me && p.is_me:
          Global.to_result(Global.EResult.SUICIDE)
        if source.is_me:
          var n = min(
            50,
            max(
              floor(p.energy / Global.RESOURCE_EATING_INTERVAL / 200),
              1
            )
          )
          for i in range(0, n):
            add_resource_effect(p.position, randf() * 0.5)
      p.destroy()

var _explosion_scene = preload("res://scene/Explosion.tscn")
func add_explosion(pos, r, duration):
  var _exps = _explosion_scene.instance()
  $Explosions.add_child(_exps)
  _exps.boom(pos, r, duration)
  _maybe_shake(pos)

func _maybe_shake(pos):
  var dis = pos.distance_to(Vector2(0, 0))
  Log.log("debug", "try shake %s ? %s" %[dis, me.field_radius])
  if dis < me.field_radius:
    $Camera.shake_camera((me.field_radius - dis) * Global.SHAKE_FACTOR)

var _re_scene = preload("res://scene/ResourceEffect.tscn")
func add_resource_effect(pos, delay):
  var re = _re_scene.instance()
  re.position = pos
  $Effects.add_child(re)
  re.start(self, delay)

var _delayed_resource_effects = []
func add_delayed_resource_effect(pos):
  _delayed_resource_effects.append(pos)

var game_start_time
func post_load():
  maybe_show_tutorial()
  game_start_time = OS.get_ticks_msec()
  for pos in _delayed_resource_effects:
    add_resource_effect(pos, 1.0)

func maybe_show_tutorial():
  Global.load_game()
  if !Global.save_dict.is_tutorial_shown == true:
    var _tutorial_ui = load("res://scene/GUI/Tutorial.tscn").instance()
    get_tree().get_root().add_child(_tutorial_ui)
    Global.save_dict.is_tutorial_shown = true
    Global.save_game()

