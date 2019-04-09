extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enabled = false
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1),"timeout")
	enabled = true
	


func _process(delta):
	if !enabled: return
	var pos = get_viewport().size/2 - get_viewport().get_mouse_position()
#	translate_object_local(Vector3(pos.x,pos.y,0)/10*delta)
#	translate_object_local(Vector3(0,0,8*delta))
	translation.x = translation.x + pos.x/50 * delta
	translation.y = translation.y + pos.y/50 * delta
	translation.z = translation.z + 15*delta
	translation.x = clamp(translation.x,-8,8)
	translation.y = clamp(translation.y,0,10)
