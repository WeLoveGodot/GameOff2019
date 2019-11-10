extends Node2D

func _ready():
	# test code
	init_planets()
	test_tween()

func test_tween():
	var t = $Tween
	print("min scale = %s", Global.MIN_SCALE)


func init_planets():
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	var half_size = Global.SIZE / 2
	for row in range(0, Global.SIZE, 5):
		for col in range(0, Global.SIZE, 5):
			var x = noise.get_noise_2d(row, col)
			if abs(x) < Global.PLANTE_GEN_PROB && $Planets.len() < Global.MAX_PLANETS:
				$Planets.new_planet(Vector2(row - half_size, col - half_size))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
