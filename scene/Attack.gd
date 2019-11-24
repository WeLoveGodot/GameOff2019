extends Node2D

signal destroy_planets(pos, r)

var r = 0
var attack_r = 0
var target: Vector2
var speed: float
var level
var is_me = false

const EXTRA_SCALE = 0.1
const DURATION_EXPLOSION = 0.5
const BASE_SIZE_EXPLS = 100
var _explosion_scale = 1.0

func _ready():
  pass

func update_scale(camera_zoom: Vector2):
  $Sprite.set_scale(camera_zoom * EXTRA_SCALE * _explosion_scale)


func launch(field_r, attack_r, speed, start: Vector2, target: Vector2, level, is_me):
  self.position = start
  $Sprite.visible = true
  self.r = field_r
  self.attack_r = attack_r
  self.target = target
  self.speed = speed
  self.level = level
  self.is_me = is_me
  var t = $Tween
  var dis = start.distance_to(target)
  $Sprite.look_at(target)
  var duration = dis / speed
  t.interpolate_property(self, "position", start, target, duration, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
  t.interpolate_callback(self, duration, "on_reach")
  t.start()

func on_reach():
  var t = $Tween
  # $Sprite.visible = false
  var duration = 0.5
  t.interpolate_property(self, "r",
        r, attack_r, DURATION_EXPLOSION,
        Tween.TRANS_EXPO, Tween.EASE_OUT)
  var target_explosion_scale = attack_r / BASE_SIZE_EXPLS / $Sprite.scale.x
  # Log.log("debug", target_explosion_scale)
  t.interpolate_property(self, "_explosion_scale",
        1.0, target_explosion_scale, DURATION_EXPLOSION,
        Tween.TRANS_EXPO, Tween.EASE_OUT, 0.15)
  t.interpolate_property($Sprite, "rotation",
        0, PI * 2, DURATION_EXPLOSION + 0.3,
        Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
  t.interpolate_property($Sprite, "modulate",
        Color(1, 1, 1), Color(0, 1, 0), DURATION_EXPLOSION + 0.3,
        Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
  t.interpolate_callback(self, 1, "on_remove")
  t.start()

func on_remove():
  _destroy_planets()
  get_parent().remove_child(self)

func _process(delta):
  pass

func _destroy_planets():
  emit_signal("destroy_planets", position, self.attack_r, level)
