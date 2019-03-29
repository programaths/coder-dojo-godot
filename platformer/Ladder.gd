extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered",self,"notify_can_climb")
	connect("body_exited",self,"notify_cant_climb")
	pass


func notify_can_climb(body):
	if body.has_method("enable_climbing"):
		body.enable_climbing()
	
func notify_cant_climb(body):
	if body.has_method("disable_climbing"):
		body.disable_climbing()
	