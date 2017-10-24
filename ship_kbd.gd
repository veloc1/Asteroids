extends Sprite

export var rotationVelocityLimit = 0.1
export var rotationAccelerationSpeed = 0.01
export var rotationAccelerationDamping = 0.003

export var accelerationSpeed = 1
export var velocityLimit = 100
export var velocityDamping = 0.04

var velocity
var acceleration
var rotationVelocity
var rotationAcceleration

func _ready():
	velocity = Vector2(0, 0)
	acceleration = 0
	rotationVelocity = 0
	rotationAcceleration = 0
	
	set_process(true)

func _process(delta):
	rotationAcceleration = 0
	acceleration = 0
	
	if Input.is_action_pressed("ui_up"):
		acceleration += accelerationSpeed
	if Input.is_action_pressed("ui_left"):
		rotationAcceleration += rotationAccelerationSpeed
	if Input.is_action_pressed("ui_right"):
		rotationAcceleration -= rotationAccelerationSpeed
	
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
	var blocks = get_tree().get_nodes_in_group("wall")
	var this = Rect2(get_pos(), get_item_rect().size)
	for block in blocks:
		var obj = Rect2(block.get_pos(), block.get_item_rect().size)
		if this.intersects(obj):
			velocity.x = -velocity.x
			velocity.y = -velocity.y

func process_offscreen():
	var x = get_pos().x
	var y = get_pos().y
	var width = get_item_rect().size.x
	var height = get_item_rect().size.y
	
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