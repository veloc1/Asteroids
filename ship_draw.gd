extends Node2D

func _ready():
	set_process(true)

func _process(delta):
	update()

func _draw():
	var nose = Vector2(0, 20)
	var taill = Vector2(10, -26)
	var tailr = Vector2(-10, -26)
	
	var lws = Vector2(0, -10)
	var rws = Vector2(0, -10)
	var lw = Vector2(30, -30)
	var rw = Vector2(-30, -30)
	var ts = Vector2(0, -25)
	
	draw_line(nose, taill, Color(1, 1, 1))
	draw_line(nose, tailr, Color(1, 1, 1))
	draw_line(lw, lws, Color(1, 1, 1))
	draw_line(rw, rws, Color(1, 1, 1))
	draw_line(rw, ts, Color(1, 1, 1))
	draw_line(lw, ts, Color(1, 1, 1))
