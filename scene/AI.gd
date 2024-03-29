extends Node

enum State {
  ITERATING = 1,
  IDLE = 2,
}

var _state = State.IDLE
var _idx = 1
# 这个是星球管理类
var _ps
var _game

var _last = -1

func _ready():
  pass # Replace with function body.

func setup(planets, game):
  _ps = planets
  _game = game

func update(delta, planets):
  var now = OS.get_ticks_msec()
  if now > _last + Global.AI_INTERVAL:
    _ai_tick(planets)
    _last = now

func _ai_tick(plantes):
  Log.log("ai", "tick")
  match _state:
    State.IDLE:
      Log.log("ai", "--> new it")
      _start_iterating(plantes)
    State.ITERATING:
      Log.log("ai", "--")
      _continue_iterating()

func _start_iterating(planets):
  _state = State.ITERATING
  _idx = 0

func _continue_iterating():
  var planets = _ps.get_children()
  if _idx >= planets.size():
    Log.log("ai", "<-- finish it")
    _state = State.IDLE
  else:
    var planet = planets[_idx]
    Log.log("ai", "it on %s" % _idx)
    if planet != null && is_instance_valid(planet):
      _run_ai(planet)
    _idx += 1

func _run_ai(planet):
  if planet.is_me:
    return
  var rd = randi() % 6
  # Log.log("ai2", "rd = %s" % rd)
  match rd:
    0:
      return
    1:
      _ai_expr(planet)
    2:
      _ai_atk(planet)
    3, 4:
      _ai_expd(planet)
    5:
      _ai_acc(planet)

func _ai_atk(planet):
  var planets_in_range = _ps.get_planets_in_range(planet.position, Global.attack_distance(planet))
  var size = planets_in_range.size()
  if size == 0 || (size == 1 && planets_in_range[0] == planet):
    return
  var target_idx = randi() % size
  while size > 1 && planets_in_range[target_idx] == planet:
    target_idx = (target_idx + 1) % size
  var target = planets_in_range[target_idx]
  _game.get_node("Skill").try_use_skill(
    planet,
    Global.ESkill.ATK,
    {
      pos = _get_random_pos(target.position, planet)
    }
  )

func _ai_expd(planet):
  _game.get_node("Skill").try_use_skill(
    planet,
    Global.ESkill.EXPD,
    null
  )

func _ai_expr(planet):
  # ai expr完全只是假装用一下然后可能被玩家发现，没意义
  Log.log("ai2", "expr")
  var dis = Global.explore_distance(planet) * max(0.5, randf()) * 2
  var deg = randf() * 2 * PI
  var target_pos = planet.position + Vector2(
    dis * sin(deg),
    dis * cos(deg)
  )
  # Log.log("debug", "%s >> (%s, %s) -> %s" % [planet.position, dis, deg, target_pos])
  _game.get_node("Skill").try_use_skill(
    planet,
    Global.ESkill.EXPR,
    {
      pos = target_pos
    }
  )

func _ai_acc(planet):
  _game.get_node("Skill").try_use_skill(
    planet,
    Global.ESkill.ACC,
    null
  )

func _get_random_pos(pos, source):
  if source.position.distance_to(pos) <= source.field_radius:
    return pos
  else:
    return Vector2(
      pos.x,
      pos.y
    )