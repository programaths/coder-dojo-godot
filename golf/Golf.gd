extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Physics2DServer.area_set_param(get_world_2d().space,Physics2DServer.AREA_PARAM_GRAVITY_VECTOR,Vector2(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
