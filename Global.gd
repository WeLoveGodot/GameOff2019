extends Node2D

# 配置

const SIZE = 4096

# fake const
var WINDOW_SIZE
var MIN_SCALE

# 星球生成概率
const PLANTE_GEN_PROB = 0.0003
# 星球生成上限
const MAX_PLANETS = 2000

func _ready():
	WINDOW_SIZE = get_viewport().size
	MIN_SCALE = WINDOW_SIZE.y / SIZE