extends Node2D

var r = 0
var target: Vector2
var speed: float

func _ready():
  pass # Replace with function body.

func launch(r, speed, start: Vector2, target: Vector2):
  self.r = r
  self.target = target
  self.speed = speed
  var t = $Tween
  var dis = start.distance_to(target)
  print("dis = ", dis)
  var duration = dis / speed
  t.interpolate_property(self, "position", start, target, duration, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
  t.interpolate_callback(self, duration, "on_reach")
  t.start()

func on_reach():
  print("reach")
  get_parent().remove_child(self)

func _process(delta):
  # print(self.position)
  pass