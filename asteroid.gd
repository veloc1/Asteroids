extends Node2D

export var verticesCount = 15
export var size = 48
export var minSize = 24
export var disposition = 5

const velocityLimit = 4

var vertices
var rotation
var velocity

func _ready():
	rotation = rand_range(-0.01, 0.01)
	velocity = Vector2(rand_range(-velocityLimit, velocityLimit), rand_range(-velocityLimit, velocityLimit))
	
	vertices = Vector2Array()
	
	var rads = 0
	var rads_inc  = (PI * 2) / verticesCount
	for i in range(verticesCount):
		rads += rads_inc
		var x = rand_range(-disposition, disposition)
		var y = rand_range(-disposition, disposition)
		vertices.append(Vector2(sin(rads) * size + x, cos(rads) * size + y))
	
	set_process(true)

func _process(delta):
	update()
	
	set_rot(get_rot() + rotation)
	var x = get_pos().x + sin(get_rot()) * velocity.x
	var y = get_pos().y + cos(get_rot()) * velocity.y
	set_pos(Vector2(x, y))
	
	process_offscreen()

func _draw():
	for v in range(vertices.size()):
		if v < vertices.size() - 1:
			draw_line(vertices[v], vertices[v + 1], Color(1, 1, 1))
		else: 
			draw_line(vertices[v], vertices[0], Color(1, 1, 1))
	
	# debug draw
	# draw_rect(get_item_rect(), Color(1,1,1, 0.5))

func process_offscreen():
	var x = get_pos().x
	var y = get_pos().y
	var width = size + size / 2 + size / 6
	var height = size + size / 2 + size / 6 
	
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	
	if x + width / 2.0 < 0:
		set_pos(Vector2(screen_width + width / 2.0, y))
	elif x - width / 2.0> screen_width:
		set_pos(Vector2(-width / 2.0, y))
	if y + height / 2.0 < 0:
		set_pos(Vector2(x, screen_height + height / 2.0))
	elif y - height / 2.0> screen_height:
		set_pos(Vector2(x, -height / 2.0))

func get_collision_rect():
	var pos = get_pos()
	var size = get_item_rect().size.x / 100.0 * 50.0
	return Rect2(Vector2(pos.x - size, pos.y - size), Vector2(size * 2, size * 2)) 

func crack():
	if size > minSize:
		for i in range(3):
			var a = get_script().new()
			a.size = size / 3
			get_tree().get_root().add_child(a)
			a.add_to_group("asteroids")
			a.set_pos(get_pos())
	queue_free()