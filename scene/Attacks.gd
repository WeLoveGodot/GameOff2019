extends Node2D

var Attack = preload("res://scene/Attack.tscn")
var game

func _ready():
	 game = get_parent()

func add_attack(field_r, attack_r, speed, start: Vector2, target: Vector2, level, is_me: bool):
	var atk = Attack.instance()
	atk.connect("destroy_planets", game, "on_destroy_planets")
	atk.launch(field_r, attack_r, speed, start, target, level, is_me)
	add_child(atk)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for atk in get_children():
		atk.update_scale(game.get_node("Camera").zoom)
