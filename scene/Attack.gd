extends Node2D

signal destroy_planets(pos, r)
signal new_explosion(pos, r, duration)

var r = 0.0
var config = {
  attack_r = 0.0,
  target = null,
  speed = 0.0,
  level = 1,
  is_me = false,
  source = null
}
const DURATION_EXPLOSION = 0.5
const BASE_SIZE_EXPLS = 100


func _ready():
  pass

func update_scale(camera_zoom: Vector2):
  $Sprite.set_scale(camera_zoom * Global.ATTACK_BASE_SCALE)


func launch(config):
  # Log.log("warning", "lauch atk %s" % config)
  position = config.start
  self.r = config.r
  $Sprite.visible = true
  self.config = config
  var t = $Tween
  var dis = config.start.distance_to(config.target)
  $Sprite.look_at(config.target)
  var duration = dis / config.speed# / 1000
  t.interpolate_property(self, "position", config.start, config.target, duration, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
  t.interpolate_callback(self, duration, "on_reach")
  t.start()

func on_reach():
  var t = $Tween
  var duration = 0.5
  t.interpolate_property(self, "r",
        r, config.attack_r, DURATION_EXPLOSION,
        Tween.TRANS_EXPO, Tween.EASE_OUT)
  $Sprite.visible = false

  emit_signal("new_explosion", position, config.attack_r, DURATION_EXPLOSION)
  # t.interpolate_property($Sprite, "rotation",
  #       0, PI * 2, DURATION_EXPLOSION + 0.3,
  #       Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
  # t.interpolate_property($Sprite, "modulate",
  #       Color(1, 1, 1), Color(0, 1, 0), DURATION_EXPLOSION + 0.3,
  #       Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
  t.interpolate_callback(self, 1, "on_remove")
  t.start()

func on_remove():
  _destroy_planets()
  get_parent().remove_child(self)

func _process(delta):
  pass

func _destroy_planets():
  emit_signal("destroy_planets", position, config.attack_r, config.level, config.source)
