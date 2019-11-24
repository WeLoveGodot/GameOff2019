# 整个Loading逻辑

extends Node

var _game

func _ready():
  pass

var _pcr
var _rcr
func setup(game):
  _game = game
  _pcr = _loading_planets_tick()
  _rcr = _loading_resources_tick()

enum ELoadingStage {
  DEFAULT,

  PLANETS,
  RESOURCES,
  ME,

  FINISH,
}

var _loading_stage = ELoadingStage.DEFAULT

var _loading_gui

func is_loading():
  return _loading_stage != ELoadingStage.DEFAULT

func start_async_loading():
  _loading_gui= load("res://scene/GUI/LoadingUI.tscn").instance()
  add_child(_loading_gui)
  _next_loading_stage()


func loading_tick(delta):
  match _loading_stage:
    ELoadingStage.DEFAULT:
      return
    ELoadingStage.PLANETS:
      _pcr = _pcr.resume()
    ELoadingStage.RESOURCES:
      _rcr = _rcr.resume()
    ELoadingStage.ME:
      _game.add_me()
      assert(_game.me != null)
      _next_loading_stage()
    ELoadingStage.FINISH:
      _loading_stage = ELoadingStage.DEFAULT
      _post_loading()

func _next_loading_stage():
  match _loading_stage:
    ELoadingStage.DEFAULT:
      _loading_stage = ELoadingStage.PLANETS
    ELoadingStage.PLANETS:
      _loading_stage = ELoadingStage.RESOURCES
    ELoadingStage.RESOURCES:
      _loading_stage = ELoadingStage.ME
    ELoadingStage.ME:
      _loading_stage = ELoadingStage.FINISH
    ELoadingStage.FINISH:
      _loading_stage = ELoadingStage.DEFAULT
  Log.log("debug", "new loading stage %s" % _loading_stage)

const PLANETS_PER_TICK = 50
var _planets_loading_state = {
  row = 0,
  col = 0
}
var _noise = _make_noise()

func _loading_planets_tick():
  yield()
  var s = Global.GEN_SIZE
  var half_size = s / 2
  Log.log("loading", "start pt %s" % _planets_loading_state)
  var count = 0
  if _planets_loading_state.row >= s && _planets_loading_state.col >= s:
    _next_loading_stage()
    return
  for row in range(0, Global.GEN_SIZE, 5):
    for col in range(0, Global.GEN_SIZE, 5):
      Log.log("loading", "try p %s %s" % [row, col])
      if count < PLANETS_PER_TICK:
        if _game.add_planet(_noise, row, col, half_size):
          count += 1
      else:
        yield()
        count = 0
  # 能到这里说明循环完了
  Log.log("warning", "p finish out %s" % _planets_loading_state)
  _next_loading_stage()

func _post_loading():
  _loading_gui.queue_free()

const RESOURCES_PER_TICK = 500
var _resources_loading_state = {
  row = 0,
  col = 0
}
func _loading_resources_tick():
  yield()
  var s = Global.GEN_SIZE
  var half_size = s / 2
  Log.log("loading", "start rt %s" % _resources_loading_state)
  var count = 0
  if _resources_loading_state.row >= s && _resources_loading_state.col >= s:
    _next_loading_stage()
    return
  for row in range(_resources_loading_state.row, s, 5):
    for col in range(_resources_loading_state.col, s, 5):
      if count < RESOURCES_PER_TICK:
        if _game.add_resource(_noise, row, col, half_size):
          count += 1
      else:
        yield()
        count = 0
  _next_loading_stage()


func _make_noise():
  var noise = OpenSimplexNoise.new()
  noise.seed = randi()
  noise.octaves = 4
  noise.period = 20.0
  noise.persistence = 0.8
  return noise
