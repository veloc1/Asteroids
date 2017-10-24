extends Node2D

var layers
var offset
var time

func _ready():
	set_process(true)
	
	offset = Vector2(0, 0)
	time = 0
	layers = []
	for i in range(5):
		layers.append(create_layer())

func _process(delta):
	time += delta
	
	update()
	move_layers()

func _draw():
	draw_rect(Rect2(0, 0, get_viewport_rect().size.x, get_viewport_rect().size.y), Color(0, 0, 0))
	
	var layerIndex = 0.0 + layers.size() + 1
	for layer in range(layers.size()):
		layerIndex = layerIndex - 1
		var shade = 1 / layerIndex
		for star in layers[layers.size() - layer - 1]:
			draw_rect(Rect2(star.x, star.y, 4, 4), Color(shade, shade, shade))

func move_layers():
	offset.x = cos(time / 2) * 0.6
	offset.y = sin(time / 2) * 0.6
	
	var player = get_tree().get_root().get_node("root/controlled_ship")
	var velocity = player.velocity
	var l = 3
	for l1 in range(layers.size()):
		var layer = layers[l1]
		layers.remove(l1)
		for i in range(layer.size()):
			var x = layer[i].x + velocity.x / l + offset.x / l
			var y = layer[i].y + velocity.y / l + offset.y / l
			var new_star = Vector2(x, y)
			
			new_star = process_star_position(new_star)
			
			layer.set(i, new_star)
		layers.insert(l1, layer)
		l = l + 1

func process_star_position(star):
	var x = star.x
	var y = star.y
	
	var screen_width = get_viewport_rect().size.x + 4
	var screen_height = get_viewport_rect().size.y + 4
	
	if x < -4:
		x = screen_width
	elif x > screen_width:
		x = -4
	if y < -4:
		y = screen_height
	elif y > screen_height:
		y = -4
	return Vector2(x, y)

func create_layer():
	var result = Vector2Array([])
	
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	
	for i in range(50):
		result.append(Vector2(rand_range(0, screen_width), rand_range(0, screen_height)))
	return result
