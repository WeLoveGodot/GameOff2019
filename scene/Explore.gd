extends Node2D

var config = {
  r = 0.0,
  speed = 1.0,
  start = null,
  target = null,
  is_me = false,
  source = null
}
const EXTRA_SCALE = 0.1

func _ready():
  pass

func update_scale(camera_zoom: Vector2):
	$Sprite.set_scale(camera_zoom * EXTRA_SCALE)


func launch(config):
  self.config = config
  position = config.start
  $Sprite.visible = true
  var t = $Tween
  var dis = config.start.distance_to(config.target)
  $Sprite.look_at(config.target)
  var duration = dis / config.speed
  # Log.log("debug", "explore: %s -> %s" % [start, target])
  t.interpolate_property(self, "position", config.start, config.target, duration, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
  t.interpolate_callback(self, duration, "on_reach")
  t.start()

func on_reach():
  get_parent().remove_child(self)

func _process(delta):
  pass