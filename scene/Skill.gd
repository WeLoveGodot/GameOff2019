extends Node2D

var game

func _ready():
  game = get_parent()

func get_skill_table(skill):
  return Global.SKILL_DICT[skill]

# 先检查能用再用
func can_use_skill(planet, skill):
  var skill_table = get_skill_table(skill)
  return planet.cost >= skill_table.cost.call_func(planet)

# 检查后同一帧赶紧用，防止bug
# 不管自己还是ai都调这个
func use_skill(planet, skill, extra_param): 
  var skill_table = get_skill_table(skill)
  var cost = skill_table.cost.call_func(planet)
  # 一手交钱，一手交货
  if planet.try_cost(cost):
    skill_table.effect.call_func(planet, game, extra_param)
  # 最后扣钱



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
