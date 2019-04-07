extends Node2D
class_name QuadrominoPiece

onready var quad = $Quadromino

var child_rotation setget set_child_rotation,get_child_rotation

func _ready():
	quad.connect("frame_changed",self, "update_offset")
	
func update_offset():
	match quad.animation:
		"O": quad.position = Vector2(48,60)
		"I": quad.position = Vector2(48,48)
		_ : quad.position = Vector2(36,36)
		
func get_offset():
	match quad.animation:
		"O": return Vector2(48,60)
		"I": return Vector2(48,48)
		_ : return Vector2(36,36)

func set_child_rotation(rot):
	quad.rotation_degrees = rot
	
func get_child_rotation():
	return quad.rotation_degrees

func set_type(type):
	if quad == null:
		call_deferred("set_type",type)
	else:
		quad.play(type)
	
func get_type():
	return quad.animation