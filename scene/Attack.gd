extends Node2D

var r = 0
var attack_r = 0
var target: Vector2
var speed: float

const EXTRA_SCALE = 0.1

func _ready():
  pass

func update_scale(camera_zoom: Vector2):
	$Sprite.set_scale(camera_zoom * EXTRA_SCALE)


func launch(field_r, attack_r, speed, start: Vector2, target: Vector2):
  self.position = start
  $Sprite.visible = true
  self.r = field_r
  self.attack_r = attack_r
  self.target = target
  self.speed = speed
  var t = $Tween
  var dis = start.distance_to(target)
  $Sprite.look_at(target)
  print("dis = ", dis)
  var duration = dis / speed
  t.interpolate_property(self, "position", start, target, duration, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
  t.interpolate_callback(self, duration, "on_reach")
  t.start()

func on_reach():
  print("reach")
  var t = $Tween
  t.interpolate_property(self, "r", 
        r, attack_r, 0.5,
        Tween.TRANS_EXPO, Tween.EASE_OUT)
  t.interpolate_callback(self, 1, "on_remove")
  t.start()

func on_remove():
  print("remove")
  get_parent().remove_child(self)

func _process(delta):
  # print(self.position)
  pass