extends Node2D

# --------------------- 基础配置 ---------------------#

const SIZE = 4096
const GEN_SIZE = SIZE * 0.75
const MAX_LEVEL = 10

const EXRA_CAMERA_HEIGHT = 50
const DEFAULT_FIELD_RADIUS = 100.0

const TECH_INTERVAL = 1000.0 # 毫秒
const AI_INTERVAL = 500.0 # 毫秒

## fake consts
var WINDOW_SIZE
var MIN_SCALE

## 星球生成概率
const PLANTE_GEN_PROB = 0.0003
## 星球生成上限
const MAX_PLANETS = 2000


# Int -> Int
func tech_2_level(tech: int):
  return floor(log(tech))

# Int -> float(0~1)
func tech_2_progress(tech: int):
  return tech / pow(10, MAX_LEVEL)

func _ready():
  WINDOW_SIZE = get_viewport().size
  MIN_SCALE = WINDOW_SIZE.y / SIZE

# --------------------- 技能逻辑配置 ---------------------#
## cost
func acc_cost(planet):
  return planet.position.x

func explore_cost(planet):
	return 0

func expand_cost(planet):
	return 0

func attack_cost(planet):
	return 0

func explore_distance(planet):
  return planet.field_radius * 2

func attack_distance(planet):
	return 0

## effect

# 暂时把技能功能也配到这里，统一管理

# 技能效果允许对自身和世界产生影响
func acc_effect(planet, game, extra_param):
  # bla bla
  pass

# 我写个示范
func expand_effect(planet, game, extra_param):
  var old_r = planet.field_radius
  var new_r = old_r * 1.1
  if planet.is_me:
    var t = planet.get_node("Tween")
    t.interpolate_property(planet, "field_radius", old_r, new_r, 0.3, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
    t.start()
  else:
    planet.field_radius  = new_r
  pass

# 支持额外参数，一个dict，比如探索之类的用户输入可以从ui层, 或ai传入
func explore_effect(planet, game, extra_param):
	# user input from extra_param
	var pos = extra_param.pos
	var r = explore_r(planet)
	var speed = explore_speed(planet)
	if planet.is_me:
		game.add_explore(r, speed, pos)

func attack_effect(planet, game, extra_param):
	pass

## special

func explore_r(planet):
	#TODO: game logic
	return 120.0

# 单位 距离 / 秒
func explore_speed(planet):
	return 100.0

enum ESkill {
  ACC,
  EXPD,
  EXPR,
  ATK,
}

# 显示技能文本的字典
var SKILL_DICT = {
  ESkill.ACC : {
    name = "Accelerate",
    cost = funcref(self, "acc_cost"),
    effect = funcref(self, "acc_effect"),
  },
  ESkill.EXPD : {
    name = "Expand",
    cost = funcref(self, "expand_cost"),
    effect = funcref(self, "expand_effect"),
  },
  ESkill.EXPR : {
    name = "Explore",
    cost = funcref(self, "explore_cost"),
    distance = funcref(self, "explore_distance"),
		effect = funcref(self, "explore_effect"),
  },
  ESkill.ATK : {
    name = "Attack",
    cost = funcref(self, "attack_cost"),
    distance = funcref(self, "attack_distance"),
    effect = funcref(self, "attack_effect"),
  },
}
# --------------------- end ---------------------#