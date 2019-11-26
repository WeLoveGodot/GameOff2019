extends Node2D

var Attack = preload("res://scene/Attack.tscn")
var game

func _ready():
	 game = get_parent()

func add_attack(config):
	var atk = Attack.instance()
	atk.connect("destroy_planets", game, "on_destroy_planets")
	atk.connect("new_explosion", game, "add_explosion")
	add_child(atk)
	atk.launch(config)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for atk in get_children():
		atk.update_scale(game.get_node("Camera").zoom)
