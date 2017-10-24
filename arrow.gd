extends Node2D

func _ready():
	set_process(true)

func _process(delta):
	update()

func _draw():
	draw_line(Vector2(0, 0), Vector2(0, 48), Color(1, 1, 1), 3)
	draw_line(Vector2(0, 48), Vector2(12, 36), Color(1, 1, 1), 3)
	draw_line(Vector2(0, 48), Vector2(-12, 36), Color(1, 1, 1), 3)