extends Sprite

const Bullet = preload("bullet.gd")

export var rotationVelocityLimit = 0.1
export var rotationAccelerationSpeed = 0.01
export var rotationAccelerationDamping = 0.003

export var accelerationSpeed = 0.1
export var velocityLimit = 10
export var velocityDamping = 0.005

var velocity
var acceleration
var rotationVelocity
var rotationAcceleration

var gameOver = false

var timer
var canShoot = false

var scores = 0

func _ready():
	velocity = Vector2(0, 0)
	acceleration = 0
	rotationVelocity = 0
	rotationAcceleration = 0
	
	timer = Timer.new()
	add_child(timer)
	
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_FIXED)
	timer.set_one_shot(false)
	timer.set_wait_time(0.3)
	
	timer.set_active(true)
	timer.start()
	
	timer.connect("timeout", self, "can_shoot")
	
	set_process(true)

func _process(delta):
	rotationAcceleration = 0
	acceleration = 0
	
	get_node("engine_right").set_emitting(false)
	get_node("engine_left").set_emitting(false)
	
	if gameOver:
		return
	
	if Input.is_action_pressed("ui_up"):
		acceleration += accelerationSpeed
		get_node("engine_right").set_emitting(true)
		get_node("engine_left").set_emitting(true)
	if Input.is_action_pressed("ui_down"):
		acceleration -= accelerationSpeed / 3.0
	if Input.is_action_pressed("ui_left"):
		rotationAcceleration += rotationAccelerationSpeed
		get_node("engine_right").set_emitting(true)
	if Input.is_action_pressed("ui_right"):
		rotationAcceleration -= rotationAccelerationSpeed
		get_node("engine_left").set_emitting(true)
	
	if Input.is_action_pressed("ui_accept"):
		fire()
		
	process_angle()
	process_velocity()
	
	translate(velocity)
	rotate(rotationVelocity)
	
	process_rotation_damping()
	process_velocity_damping()
	
	process_collisions()
	
	process_offscreen()

func process_angle():
	rotationVelocity += rotationAcceleration
	rotationVelocity = clamp(rotationVelocity, -rotationVelocityLimit, rotationVelocityLimit)

func process_velocity():
	velocity.x += sin(get_rot()) * acceleration
	velocity.y += cos(get_rot()) * acceleration
	
	velocity = velocity.clamped(velocityLimit)

func process_rotation_damping():
	if rotationVelocity > rotationAccelerationDamping:
		rotationVelocity -= rotationAccelerationDamping
	elif rotationVelocity < - rotationAccelerationDamping:
		rotationVelocity += rotationAccelerationDamping
	else:
		rotationVelocity = 0

func process_velocity_damping():
	velocity.x -= velocity.x * velocityDamping
	velocity.y -= velocity.y * velocityDamping

func process_collisions():
	var asteroids = get_tree().get_nodes_in_group("asteroids")
	var this = get_collision_rect()
	for a in asteroids:
		var rect = a.get_collision_rect()
		if rect.intersects(this):
			gameOver = true
			a.queue_free()

func process_offscreen():
	var x = get_pos().x
	var y = get_pos().y
	var width = get_item_rect().size.x
	var height = get_item_rect().size.y
	
	width = get_node("ship").get_item_rect().size.x
	height = get_node("ship").get_item_rect().size.y
	
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	
	if x + width / 2 < 0:
		set_pos(Vector2(screen_width + width / 2, y))
	elif x - width / 2> screen_width:
		set_pos(Vector2(-width / 2, y))
	if y + height / 2 < 0:
		set_pos(Vector2(x, screen_height + height / 2))
	elif y - height / 2> screen_height:
		set_pos(Vector2(x, -height / 2))

func get_collision_rect():
	var pos = get_pos()
	var size = get_item_rect().size.x / 100.0 * 50.0
	return Rect2(Vector2(pos.x - size, pos.y - size), Vector2(size * 2, size * 2)) 

func can_shoot():
	canShoot = true

func fire():
	if canShoot:
		var bullet = Bullet.new()
		var x = get_pos().x + sin(get_rot()) * 35
		var y = get_pos().y + cos(get_rot()) * 35
		bullet.set_pos(Vector2(x, y))
		bullet.set_rot(get_rot())
		bullet.add_to_group("bullets")
		get_tree().get_root().add_child(bullet)
	canShoot = false

func increment_scores():
	scores = scores + 1
	print(str(get_tree().get_nodes_in_group("asteroids").size()))
	if get_tree().get_nodes_in_group("asteroids").size() == 0:
		get_parent().increment_level()