extends Control


onready var Cam = get_node("../Camera")
onready var Player = get_node("../Player")
onready var TextLabel = get_node("RichTextLabel")

func _process(delta):
	TextLabel.clear()
	TextLabel.text += "PlayerCheck position:" + String(Cam.PlayerCheck.global_transform.origin) + "\n"
	TextLabel.text += "Fov: " + String(Cam.fov) + "\n" 
	TextLabel.text += "Height: " + String(Cam.height) + "\n" 
	TextLabel.text += "Cam position: " + String(Cam.global_transform.origin) + "\n"
	TextLabel.text += "======================================" + "\n"
	TextLabel.text += "Cam left: " + String(Cam.RaycastLeft.is_colliding()) + "\n"
	TextLabel.text += "Cam right: " + String(Cam.RaycastRight.is_colliding()) + "\n"
	TextLabel.text += "======================================" + "\n"
	for rc in Cam.SwiskersRight.get_children():
		if rc.is_colliding():
			TextLabel.text += rc.name + "is colliding with " + rc.get_collider().name + "\n"
	for rc in Cam.SwiskersLeft.get_children():
		if rc.is_colliding():
			TextLabel.text += rc.name + "is colliding with " + rc.get_collider().name + "\n"
	
	
	
	