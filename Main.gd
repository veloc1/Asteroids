extends Node

const Asteroid = preload("asteroid.gd")

var level = 0

func _ready():
	set_process(true)
	
	set_level(0)

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	var player = get_node("controlled_ship")
	get_tree().get_root().get_node("root/scores").set_text(str(player.scores))
	
	if player.gameOver:
		player.hide()
		var gO = get_node("game_over")
		
		var x = get_viewport().get_rect().size.x / 2 - gO.get_item_rect().size.x / 2.0 * gO.get_scale().x
		var y = get_viewport().get_rect().size.y / 2 - gO.get_item_rect().size.y / 2.0 * gO.get_scale().y
		var center = Vector2(x, y)
		
		gO.set_pos(center)
		gO.show()
		
		if Input.is_action_pressed("restart"):
			player.gameOver = false
			set_level(0)
			
			gO.hide()
			player.show()
			player.scores = 0

func set_level(difficulty):
	level = difficulty
	var player = get_node("controlled_ship")
	var x = get_viewport().get_rect().size.x / 2 - player.get_collision_rect().size.x / 2.0
	var y = get_viewport().get_rect().size.y / 2 - player.get_collision_rect().size.y / 2.0
	var center = Vector2(x, y)
	player.set_pos(center)
	
	for a in get_tree().get_nodes_in_group("asteroids"):
		a.queue_free()
	for b in get_tree().get_nodes_in_group("bullets"):
		b.queue_free()
	
	for i in range((difficulty + 1) * 3):
		var a = Asteroid.new()
		var x = rand_range(0, get_viewport().get_rect().size.x)
		var y = rand_range(0, get_viewport().get_rect().size.y)
		get_tree().get_root().call_deferred("add_child", a)
		a.add_to_group("asteroids")
		a.set_pos(Vector2(x, y))

func increment_level():
	set_level(level + 1)
