extends Node2D

signal energy_changed

const MAX_SCALE = 1
const MIN_SCALE = 0.4

const EXTRA_SCALE = 0.25

var last: float = 0.0

# 一个星球的建模，不管是自己还是ai

var field_radius = Global.DEFAULT_FIELD_RADIUS
var level: int = Global.tech_2_level(Global.INITIAL_TECH)
var energy : int = floor(Global.area(Global.DEFAULT_FIELD_RADIUS) * Global.ENERGY_DENSITY)
# var energy : int = 3
var tech: int = Global.INITIAL_TECH
var tech_factor = Global.INITIAL_DEVELOP_FACTOR
var progress: float = Global.tech_2_progress(Global.INITIAL_TECH)

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
		emit_signal("energy_changed")
		return true

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

func get_energy():
	return self.energy

func set_energy(energy: int):
	self.energy = energy

func _process(delta):
	var now = OS.get_ticks_msec()
	if now > last + Global.TECH_INTERVAL:
		tick()
		last = now