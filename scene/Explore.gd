extends Node2D

var r = 0
var target: Vector2
var speed: float
var is_me = false

const EXTRA_SCALE = 0.1

func _ready():
  pass

func update_scale(camera_zoom: Vector2):
	$Sprite.set_scale(camera_zoom * EXTRA_SCALE)


func launch(r, speed, start: Vector2, target: Vector2, is_me):
  self.position = start
  self.r = r
  self.target = target
  self.speed = speed
  self.is_me = is_me
  $Sprite.visible = true
  var t = $Tween
  var dis = start.distance_to(target)
  $Sprite.look_at(target)
  print("dis = ", dis)
  var duration = dis / speed
  Log.log("debug", "explore: %s -> %s" % [start, target])
  t.interpolate_property(self, "position", start, target, duration, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
  t.interpolate_callback(self, duration, "on_reach")
  t.start()

func on_reach():
  print("reach")
  get_parent().remove_child(self)

func _process(delta):
  # print(self.position)
  pass