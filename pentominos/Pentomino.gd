extends Area2D

var drag = false
var _offset = Vector2()

signal clicked(target)
signal mouse_enter(target)
signal mouse_leave(target)

func _ready():
	add_to_group("pentominos")
	connect("mouse_entered",self,"mouse_entered")
	connect("mouse_exited",self,"area_exited")
	
func mouse_entered():
	emit_signal("mouse_enter",self)
	
func area_exited():
	emit_signal("mouse_leave",self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drag:
		position = get_global_mouse_position() - _offset


func grab(offset):
	drag = true
	_offset = offset

func release():
	drag = false