extends Node

enum State {
  ITERATING = 1,
  IDLE = 2,
}

var _state = State.IDLE
var _idx = 1
var _planets
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
    ai_tick(planets)
    _last = now

func ai_tick(plantes):
  print("[ai] tick")
  match _state:
    State.IDLE:
      print("[ai] --> new it")
      start_iterating(plantes)
    State.ITERATING:
      print("[ai] --")
      continue_iterating()

func start_iterating(planets):
  _planets = planets
  _state = State.ITERATING
  _idx = 0

func continue_iterating():
  if _idx >= _planets.size():
    print("[ai] <-- finish it")
    _state = State.IDLE
  else:
    var planet = _planets[_idx]
    print("[ai] it on ", _idx)
    # TODO: null check?
    run_ai(planet)
    _idx += 1

func run_ai(planet):
  if planet.is_me:
    return
  var rd = randi() % 5
  print("[ai] rd = ", rd)
  match rd:
    0:
      return
    1:
      ai_atk(planet)
    2:
      ai_expd(planet)
    3:
      ai_expr(planet)
    4:
      ai_acc(planet)

func ai_atk(planet):
  var planets_in_range = _ps.get_planets_in_range(planet.position, Global.attack_distance(planet))
  var size = planets_in_range.size()
  if size == 0 || (size == 1 && planets_in_range[0] == planet):
    return
  var target_idx = randi() % size
  while size > 1 && planets_in_range[target_idx] == planet:
    target_idx = (target_idx + 1) % size
  var target = planets_in_range[target_idx]
  _game.get_node("Skill").use_skill(
    planet,
    Global.ESkill.ATK,
    {
      pos = target.position
    }
  )

func ai_expd(planet):
  pass

func ai_expr(planet):
  pass

func ai_acc(planet):
  pass