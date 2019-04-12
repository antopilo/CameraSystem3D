extends InterpolatedCamera

export var CameraDistance = 5
export var CameraMinDistance = 3
var up = Vector3(0,1,0)

var rotateSpeed = 2
var CurrentDistance = 0
var height = 3
var MaxHeight = 12
var height_from_ground = 2

# References
onready var Player = get_node("../Player")
onready var cam_target = get_node("../Player/CameraTarget")

# Raycasts
onready var RaycastGround = get_node("RaycastGround")
onready var RaycastUp = get_node("RaycastUp")
onready var RaycastLeft = get_node("RaycastLeft")
onready var RaycastRight = get_node("RaycastRight")



onready var PlayerCheck = get_node("PlayerCheck")
onready var RaycastBack = get_node("RaycastBack")
onready var RaycastLedge = PlayerCheck.get_node("Front")
onready var RacycastSwiskerL = PlayerCheck.get_node("SwiskerL")
onready var RacycastSwiskerR = PlayerCheck.get_node("SwiskerR")

var Velocity = Vector3()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	CurrentDistance = (Vector3(global_transform.origin.x, 0 , global_transform.origin.z) - get_node(target).global_transform.origin).length()
	speed = clamp(CurrentDistance - CameraDistance, 0, 5)
	fov = clamp(((1 / (CurrentDistance / CameraDistance)) * 30) + 55, 55, 90)
	
	CheckCollision(delta)
	CheckDistance(delta)
	CheckPlayer(delta)
	
	self.transform.origin = Vector3(self.transform.origin.x, cam_target.transform.origin.y + height,self.transform.origin.z)
	Rotate(delta)
	look_at(cam_target.global_transform.origin, up)
	
	
func CheckCollision(delta):
	if(RaycastGround.is_colliding()):
		var raycastlength = (RaycastRight.global_transform.origin -  RaycastRight.get_collision_point()).length()
		var pushSpeed = (raycastlength / 2) * 10
		self.global_transform.origin += Vector3(0, pushSpeed * delta, 0 )
		
	# Spin Right
	
	if(RacycastSwiskerL.is_colliding()):
		var raycastlength = (RacycastSwiskerL.global_transform.origin -  RacycastSwiskerL.get_collision_point()).length()
		var pushSpeed = (abs(raycastlength) / 3.16) * 5
		self.transform.origin += (global_transform.basis[0] * pushSpeed) * delta
	elif(RaycastLeft.is_colliding()):
		var raycastlength = (RaycastLeft.global_transform.origin -  RaycastLeft.get_collision_point()).length()
		var pushSpeed = (abs(raycastlength) / 2) * 5
		self.global_transform.origin -= Vector3(pushSpeed * delta, 0, 0 )
		print("RaycastLeft!")
	# Spin Left
	
	if(RacycastSwiskerR.is_colliding() && RacycastSwiskerR.get_collision_normal().angle_to(self.global_transform.origin) < 45):
		var raycastlength = (RacycastSwiskerR.global_transform.origin - RacycastSwiskerR.get_collision_point()).length()
		var pushSpeed = (abs(raycastlength) / 3.16) * 5
		self.transform.origin -= (global_transform.basis[0] * pushSpeed) * delta
	elif(RaycastRight.is_colliding()):
		var raycastlength = (RaycastRight.global_transform.origin -  RaycastRight.get_collision_point()).length()
		var pushSpeed = -(abs(raycastlength) / 2) * 5
		self.global_transform.origin += Vector3(pushSpeed * delta, 0, 0)
		print("RaycastRight!")
	#if(RaycastBack.is_colliding()):
	#	self.global_transform.origin += Vector3(0, 5 * delta, 0)
	print(".")
func CheckDistance(delta):
	if CurrentDistance <= CameraMinDistance:
		self.transform.origin -= Vector3(0, 0, (rotateSpeed * 2) * delta)
	
		
func CheckPlayer(delta):
	PlayerCheck.global_transform.origin = Player.global_transform.origin
	PlayerCheck.rotation_degrees = Vector3(-self.rotation_degrees.x,0,0)
	
	
	if !RaycastLedge.is_colliding() && height < MaxHeight:
		height += rotateSpeed*delta
		
	
func Rotate(delta):
	if Input.is_action_pressed("cam_right"):
		self.transform.origin += (global_transform.basis[0] * rotateSpeed * 4) * delta
	elif Input.is_action_pressed("cam_left"):
		self.transform.origin -= (global_transform.basis[0] * rotateSpeed * 4) * delta
	
	
	if Input.is_action_pressed("cam_up") and !RaycastUp.is_colliding() && height < MaxHeight:
		height += rotateSpeed * delta
	elif Input.is_action_pressed("cam_down") and !RaycastGround.is_colliding():
		height -= rotateSpeed * delta