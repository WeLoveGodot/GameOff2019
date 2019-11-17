extends Node2D

var Explore = preload("res://scene/Explore.tscn")

func _ready():
	pass # Replace with function body.

func add_explore(r, speed, start: Vector2, target: Vector2):
	var expr = Explore.instance()
	expr.launch(r, speed, start, target)
	add_child(expr)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
