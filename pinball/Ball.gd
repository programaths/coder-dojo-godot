extends RigidBody2D

class_name Ball,"res://pinball/sprites/ball.png"

onready var initial_pos=position
onready var vn = $VisibilityNotifier2D

func _ready():
	vn.connect("screen_exited",self,"reset")

func reset():
	linear_velocity=Vector2()
	position = initial_pos