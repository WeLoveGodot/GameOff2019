extends Sprite

func _ready():
  pass # Replace with function body.

const D = 0.3
const D2 = 0.4
const BASE_DISTANCE = 50

var _scale = 1

var _game

# 抖两下然后飞到中间去
func start(game, delay):
  var t = $Tween
  _game = game
  t.interpolate_property(
    self,
    "position",
    position,
    position + Vector2(randf() - 0.5, randf() - 0.5) * BASE_DISTANCE * _game.get_node("Camera").zoom,
    D,
    Tween.TRANS_LINEAR,
    Tween.EASE_IN_OUT,
    delay
  )
  t.interpolate_property(
    self, "_scale",
    1, 2,
    D,
    Tween.TRANS_LINEAR,
    Tween.EASE_IN_OUT,
    delay
  )
  t.interpolate_property(
    self, "position",
    position,
    Vector2(0, 0),
    D2,
    Tween.TRANS_EXPO,
    Tween.EASE_OUT,
    D + delay
  )
  t.interpolate_callback(
    self,
    D + D2 + delay,
    "_delete"
  )
  t.start()

func _delete():
  self.queue_free()

func _process(delta):
  set_scale(_game.get_node("Camera").zoom * Global.RESOURCE_BASE_SCALE * _scale)