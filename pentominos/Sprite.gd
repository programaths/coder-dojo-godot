tool
extends Node2D

export (Texture) var texture

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	update()

func _draw():
	if texture:
		var offset:Vector2 =  global_position.snapped(Vector2(32,32)) - global_position
		
		offset = offset.rotated(-global_rotation)
		draw_texture(texture,offset,Color(0,0,0,0.4))
		draw_texture(texture,Vector2(0,0))