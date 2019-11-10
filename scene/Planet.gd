extends Node2D

const MAX_SCALE = 1
const MIN_SCALE = 0.4

var last: float = 0.0

# 一个星球的建模，不管是自己还是ai
# 所以这个scene不能包含ai逻辑，但可包含行为的接口，之后accept一个控制者（玩家或ai）即可工作

var field_radius: int = Global.DEFAULT_FIELD_RADIUS
var level: int = 0
var energy : int = 0
var tech: int = 1
var tech_factor = 1
var progress: float = 0.0

func _ready():
	pass

# public

func set_coor(coor: Vector2):
	set_position(coor)

func update_scale(camera_zoom: Vector2):
	$Sprite.set_scale(camera_zoom * 0.5)

func tick():
	# field_radius += 20
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
	return self.coor

func _process(delta):
	var now = OS.get_ticks_msec()
	if now > last + Global.TECH_INTERVAL:
		tick()
		last = now