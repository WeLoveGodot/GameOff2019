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
  match _state:
    State.IDLE:
      start_iterating(plantes)
    State.ITERATING:
      continue_iterating()

func start_iterating(planets):
  _planets = planets

func continue_iterating():
  if _idx >= _planets.size():
    _state = State.IDLE
  else:
    var planet = _planets[_idx]
    # TODO: null check?
    run_ai(planet)

func run_ai(planet):
  if planet.is_me:
    return
  var rd = randi() % 5
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
  var planets_in_range = _ps.get_planets_in_range(planet.position, planet.field_radius)
  var size = planets_in_range.size()
  if size > 0:
    var target = planets_in_range[randi() % size]
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