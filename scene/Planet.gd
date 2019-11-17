extends Node2D

signal enegy_changed

const MAX_SCALE = 1
const MIN_SCALE = 0.4

const EXTRA_SCALE = 0.25

var last: float = 0.0

# 一个星球的建模，不管是自己还是ai

var field_radius: float = Global.DEFAULT_FIELD_RADIUS
var level: int = 0
var energy : int = 0
var tech: int = 1
var tech_factor = 1
var progress: float = 0.0

# 特殊标记是不是主角
var is_me: bool = false

func _ready():
	pass

# public

func set_coor(coor: Vector2):
	set_position(coor)

func update_scale(camera_zoom: Vector2):
	$Sprite.set_scale(camera_zoom * EXTRA_SCALE)

func try_cost(cost: int):
	if cost > energy:
		return false
	else:
		energy -= cost
		emit_signal("enegy_changed")

func tick():
	# field_radius += 200
	update_tech()
	update_progress()
	update_level()

func update_tech():
	tech = tech * tech_factor

func update_progress():
	progress = Global.tech_2_progress(tech)

func update_level():
	level = Global.tech_2_level(tech)

func get_coor():
	return position

func _process(delta):
	var now = OS.get_ticks_msec()
	if now > last + Global.TECH_INTERVAL:
		tick()
		last = now