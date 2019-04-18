extends Node2D

var path = []

func _ready():
	pass # Replace with function body.

func draw_path(p_path):
	path = p_path
	update()
	
func clear_path():
	path = []
	update()


func _draw():
	if path.size()>1:
#		var line = PoolVector2Array()
		for i in range(path.size()-1):
#			line.append(path[i].position)
#			line.append(path[i+1].position)
			draw_line(path[i].position,path[i+1].position,Color(1,0,0,0.2),16)
#		draw_multiline(line,Color(1,0,0,0.2),16)