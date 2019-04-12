extends KinematicBody

var InputDirection = Vector3(0, 0, 0)

var gravity = -9.8
var Velocity = Vector3()

const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var camera = get_node("../Camera").global_transform
	var dir = Vector3()
	var moving = false
	
	if(Input.is_action_pressed("move_up")):
		dir += -camera.basis[2]
		moving = true
	if(Input.is_action_pressed("move_down")):
		dir += camera.basis[2]
		moving = true
	if(Input.is_action_pressed("move_left")):
		dir += -camera.basis[0]
		moving = true
	if(Input.is_action_pressed("move_right")):
		dir += camera.basis[0]
		moving = true
		
	dir.y = 0
	dir = dir.normalized()
	
	Velocity.y += delta * gravity
	
	var hv = Velocity
	hv.y = 0


	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION

	if (dir.dot(hv) > 0):
		accel = ACCELERATION

	hv = hv.linear_interpolate(new_pos, accel * delta)
	Velocity.x = hv.x
	Velocity.z = hv.z
	
	if moving:
		# Rotate the player to direction
		var angle = atan2(hv.x, hv.z)
		
		var char_rot = self.get_rotation()
		
		char_rot.y = angle
		self.set_rotation(char_rot)
		
	Velocity = move_and_slide(Velocity, Vector3(0,1,0))

func GetInput():
	if Input.is_action_pressed("ui_up"):
		InputDirection.z = -1
	elif Input.is_action_pressed("ui_down"):
		InputDirection.z = 1
	else:
		InputDirection.z = 0
		
	if Input.is_action_pressed("ui_left"):
		InputDirection.x = -1
	elif Input.is_action_pressed("ui_right"):
		InputDirection.x = 1
	else:
		InputDirection.x = 0
		
	