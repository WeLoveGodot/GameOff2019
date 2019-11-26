extends Sprite

var _s = 1.0

var _size

func _ready():
  _size = texture.get_width()
  visible = false
  pass # Replace with function body.

func boom(pos: Vector2, r: float, duration: float):
  var t = $Tween
  position = pos
  visible = true
  t.interpolate_property(self, "_s",
        1, r / _size, duration,
        Tween.TRANS_EXPO, Tween.EASE_OUT, 0.15)
  t.interpolate_callback(self, duration, "on_remove")
  t.start()


func on_remove():
  self.queue_free()

func _process(delta):
  var s = _s * Global.ATTACK_BASE_SCALE
  set_scale(Vector2(s, s))