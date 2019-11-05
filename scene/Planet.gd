extends Node2D

# 一个星球的建模，不管是自己还是ai
# 所以这个scene不能包含ai逻辑，但可包含行为的接口，之后accept一个控制者（玩家或ai）即可工作

# 视野半径
var vision: float = 0.0

# ...

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
