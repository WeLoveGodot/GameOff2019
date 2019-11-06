extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = self.owner
	print(game)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for planet in game.get_planets():
		var view_coor = game.get_view_coor(planet.get_coor())
		print(view_coor)
		planet.position = view_coor
