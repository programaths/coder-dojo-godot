tool
extends Area2D

class_name LetterTile,"res://wordgame/sprites/letter_A.png"


onready var spr = $Sprite

signal clicked(target)
signal released(target)
signal hover_pressed(target)

export(String," ","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z") var letter setget set_letter,get_letter

var _letter

func _ready():
	add_to_group("tiles")
	connect("input_event",self,"input")
	connect("mouse_entered",self, "mouse_in")

func input(viewport:Node,event:InputEvent,shape_idx:int):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("clicked",self)
		else:
			emit_signal("released",self)

func mouse_in():
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		emit_signal("hover_pressed",self)
	
func set_letter(l):
	if l==null:
		return
	_letter = l
	if not spr:
		yield(self,"ready")
		call_deferred("set_letter",l)
		return
	if l==" ":
		spr.play("space")
	else:
		spr.play(l)

func get_letter():
	return _letter