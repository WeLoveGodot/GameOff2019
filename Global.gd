extends Node2D

# 配置

const SIZE = 4096
const GEN_SIZE = SIZE * 0.75
const MAX_LEVEL = 10

const EXRA_CAMERA_HEIGHT = 50
const DEFAULT_FIELD_RADIUS = 10

# ms
const TECH_INTERVAL = 1000.0
const AI_INTERVAL = 500.0

# fake const
var WINDOW_SIZE
var MIN_SCALE

# 星球生成概率
const PLANTE_GEN_PROB = 0.0003
# 星球生成上限
const MAX_PLANETS = 2000

func acc_cost(planet):
	return planet.position.x

func explore_cost(planet):
	pass

func expand_cost(planet):
	pass

func attack_cost(planet):
	pass

func explore_distance(planet):
	return planet.field_radius * 2

func attack_distance(planet):
	pass

# 显示技能文本的字典
var SKILL_DICT = {
	"accelerate": {
		"name": "Accelerate",
		"cost": funcref(self, "acc_cost"),
	},
	"expand": {
		"name": "Expand",
		"cost": funcref(self, "expand_cost"),
	},
	"explore": {
		"name": "Explore",
		"cost": funcref(self, "explore_cost"),
		"distance": funcref(self, "explore_distance"),
	},
	"attack": {
		"name": "Attack",
		"cost": funcref(self, "attack_cost"),
		"distance": funcref(self, "attack_distance"),
	},
}

# Int -> Int
func tech_2_level(tech: int):
	return floor(log(tech))

# Int -> float(0~1)
func tech_2_progress(tech: int):
	return tech / pow(10, MAX_LEVEL)

func _ready():
	WINDOW_SIZE = get_viewport().size
	MIN_SCALE = WINDOW_SIZE.y / SIZE