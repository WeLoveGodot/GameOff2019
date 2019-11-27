extends Sprite

# 爆炸指数，从0到r
var _s = 0

var _size
var _r

func _ready():
  _size = texture.get_width() / 2
  Log.log("info", "SIZE = %s" % _size)
  visible = false
  pass # Replace with function body.

func boom(pos: Vector2, r: float, duration: float):
  var t = $Tween
  position = pos
  visible = true
  _r = r
  Log.log("info", "r = %s" % _r)
  t.interpolate_property(self, "_s",
        0.0, 1.0, duration,
        Tween.TRANS_EXPO, Tween.EASE_OUT, 0.15)
  t.interpolate_callback(self, duration, "on_remove")
  t.start()


func on_remove():
  self.queue_free()

func _process(delta):
  # _s == 1 -> scale to r -> scale = _r / _size
  var s = _s * (_r / _size)
  Log.log("info", "scale = %s" % s)
  set_scale(Vector2(s, s))