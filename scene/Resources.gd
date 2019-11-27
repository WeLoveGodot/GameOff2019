extends Node2D

var Resource = preload("res://scene/Resource.tscn")
var game

var resources = []
# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent()

# 星球吃资源
func eat_resource(source, pos, r, is_delay_effect):
	var rs = get_in_range(pos, r)
	var sum = calc_energy(rs)
	delete_resources(rs, source.is_me, is_delay_effect)
	return sum

func add_resource(pos):
	var resource = Resource.instance()
	resource.position = pos
	resource.rotation = randf() * 180
	add_child(resource)


func calc_energy(resources):
	# 临时大家够一样，直接简单算了
	return resources.size() * Global.RESOURCE_ENERGY

func get_in_range(pos, r):
	var rs = []
	for resource in get_children():
		var x = resource.position.x
		var y = resource.position.y
		if pos.distance_to(resource.position) < r:
			rs.append(resource)
	return rs

func delete_resources(rs, is_need_effect, is_delay_effect):
	for r in rs:
		if is_need_effect:
			if is_delay_effect:
				game.add_delayed_resource_effect(r.position)
			else:
				game.add_resource_effect(r.position, 0)
		r.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for r in get_children():
		r.set_scale(game.get_node("Camera").zoom * Global.RESOURCE_BASE_SCALE)

func _draw():
	pass
	# for resource in resources:
	# 	draw_texture(resource_texture, resource.pos)