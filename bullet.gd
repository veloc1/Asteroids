extends Node2D

var timer
var velocity = 20

func _ready():
	set_process(true)
	
	timer = Timer.new()
	add_child(timer)
	
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	timer.set_one_shot(true)
	timer.set_wait_time(0.3)
	
	timer.set_active(true)
	timer.start()

func _process(delta):
	if timer.get_time_left() <= 0:
		get_parent().remove_child(self)
		free()
	else:
		var x = get_pos().x + sin(get_rot()) * velocity
		var y = get_pos().y + cos(get_rot()) * velocity
		
		set_pos(Vector2(x, y))
		update()
		process_offscreen()
		
		check_collisions()

func _draw():
	draw_rect(Rect2(Vector2(-2, -2), Vector2(4, 4)), Color(1, 1, 1))


func process_offscreen():
	var x = get_pos().x - 2
	var y = get_pos().y - 2
	var width = 4
	var height = 4
	
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

func check_collisions():
	var asteroids = get_tree().get_nodes_in_group("asteroids")
	for a in asteroids:
		var rect = a.get_collision_rect()
		if rect.has_point(get_pos()):
			queue_free()
			a.crack()
			get_tree().get_root().get_node("root/controlled_ship").call_deferred("increment_scores")