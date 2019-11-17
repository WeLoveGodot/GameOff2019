extends Node2D

# --------------------- 基础配置 ---------------------#

const SIZE = 4096
const GEN_SIZE = SIZE * 0.75
const MAX_LEVEL = 9

const DEFAULT_FIELD_RADIUS = 100.0

const TECH_INTERVAL = 10000.0 # 毫秒
const AI_INTERVAL = 500.0 # 毫秒
const RESOURCE_EATING_INTERVAL = 100.0 # 10fps

## fake consts
var WINDOW_SIZE
var MIN_SCALE

## 星球生成概率
const PLANTE_GEN_PROB = 0.00001
## 资源生成概率
const RESOURCE_GEN_PROB = 0.003
## 资源能量值
const RESOURCE_ENERGY = 10
## 星球生成上限
const MAX_PLANETS = 2000

## 基础宇宙常量
const ENERGY_DENSITY = 800
const PAI = 3
const COSMOS_RADIUS = 1024

const INITIAL_FIELD_RADIUS = 5
const INITIAL_TECH = 16
const INITIAL_DEVELOP_FACTOR = 2
 
const EXPAND_COST_FACTOR = 1.0
const EXPLORE_COST_FACTOR = 1.0
const ATTACK_COST_FACTOR = 1.0
const EXPLORE_FACTOR = 2.0
const BASE_EXPLORE_RADIUS = 35.0
const BASE_EXPLORE_VELOCITY = 100
const BASE_ATTACK_RADIUS = 1
const BASE_ATTACK_VELOCITY = 50
const EXPAND_RADIUS_FACTOR = 1.1

# Int -> Int
func tech_2_level(tech: int):
  return floor(log(tech)/log(10))

# Int -> float(0~1)
func tech_2_progress(tech: int):
  return tech / pow(10, MAX_LEVEL)

func _ready():
  WINDOW_SIZE = get_viewport().size
  MIN_SCALE = WINDOW_SIZE.y / SIZE

# --------------------- 技能逻辑配置 ---------------------#
## cost
func area(r):
  return PAI * r * r

func acc_cost(planet):
  return 0

func explore_cost(planet):
  return explore_distance(planet) * explore_radius(planet) * EXPLORE_COST_FACTOR

func expand_cost(planet):
  var expand_radius = ceil(planet.field_radius * EXPAND_RADIUS_FACTOR)
  var increased_area = area(expand_radius) -  area(planet.field_radius)
  return increased_area * EXPAND_COST_FACTOR

func attack_cost(planet):
  var attack_radius = planet.level * BASE_ATTACK_RADIUS
  return area(attack_radius) * ATTACK_COST_FACTOR

func attack_distance(planet):
  return 0

## effect

# 暂时把技能功能也配到这里，统一管理

# 技能效果允许对自身和世界产生影响
func acc_effect(planet, game, extra_param):
  # bla bla
  planet.tech_factor += 1

# 我写个示范
func expand_effect(planet, game, extra_param):
  var old_r = planet.field_radius
  var new_r = old_r * 1.1
  if planet.is_me:
    var t = planet.get_node("Tween")
    var duration = 0.3
    t.interpolate_property(planet, "field_radius", old_r, new_r, duration, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
    t.interpolate_callback(game, duration, "eat_resource", planet)
    t.start()
  else:
    planet.field_radius = new_r
  pass

# 支持额外参数，一个dict，比如探索之类的用户输入可以从ui层, 或ai传入
func explore_effect(planet, game, extra_param):
	# user input from extra_param
	var pos = global_pos_2_explore_pos(explore_distance(planet), extra_param.pos)
	var r = explore_radius(planet)
	print(planet.level)
	print(r)
	var speed = explore_velocity(planet)
	if planet.is_me:
		game.add_explore(r, speed, pos)

func attack_effect(planet, game, extra_param):
	pass
	

func global_pos_2_explore_pos(d, pos):
	var a = atan2(pos.y, pos.x)
	return Vector2(d * cos(a), d * sin(a))

## special

func explore_radius(planet):
  return planet.level * BASE_EXPLORE_RADIUS * 1.0

# 单位 距离 / 秒
func explore_velocity(planet):
	return planet.level * BASE_EXPLORE_VELOCITY * 1.0

func explore_distance(planet):
  return planet.field_radius * EXPLORE_FACTOR


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