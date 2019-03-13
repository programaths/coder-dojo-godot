extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var plunger = $Body
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("ui_down"):
		plunger.add_force(Vector2(0,0),Vector2(0,32))
	if Input.is_action_just_released("ui_down"):
		plunger.applied_force.y=0