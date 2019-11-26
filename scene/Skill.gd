extends Node2D

var game
var attack
var explore

func _ready():
  game = get_parent()
  attack = game.get_node("attack")
  explore = game.get_node("explore")

func get_skill_table(skill):
  return Global.SKILL_DICT[skill]

# 懒人接口
func try_use_skill(planet, skill, extra_param):
  if can_use_skill(planet, skill):
    use_skill(planet, skill, extra_param)


# 先检查能用再用
func can_use_skill(planet, skill):
  var skill_table = get_skill_table(skill)
  return planet.energy >= skill_table.cost.call_func(planet)

# 检查后同一帧赶紧用，防止bug
# 不管自己还是ai都调这个
func use_skill(planet, skill, extra_param):
  var skill_table = get_skill_table(skill)
  var cost = skill_table.cost.call_func(planet)
  # 一手交钱，一手交货
  if planet.is_me:
    Log.log("error", "%s : %s"%[skill_table.name, cost])
  if planet.try_cost(cost):
    if planet.is_me:
      if skill == Global.ESkill.ATK:
        attack.play()
      elif skill == Global.ESkill.EXPR:
        explore.play()
    skill_table.effect.call_func(planet, game, extra_param)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
