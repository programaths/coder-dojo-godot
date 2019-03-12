extends Area2D

export(int,"spade","heart","diamon","club") var suite=0 setget s_suite
export(int,0,12) var value=0 setget s_value

signal clicked
signal revealed
signal concealed

onready var sprite=$Sprite
onready var back=$cardBack
onready var tween=$Tween
var locked = false

func _ready():
	pass # Replace with function body.

func s_suite(v):
	suite=v
	call_deferred("set_sv")
	
func s_value(v):
	value=v
	call_deferred("set_sv")
	
func set_sv():
	sprite.region_rect.position = Vector2(363*value,543*suite)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==BUTTON_LEFT:
		if locked: return
		emit_signal("clicked",self)

func lock():
	locked = true
	
func unlock():
	locked = false
	
func same(other):
	return suite == other.suite and value == other.value

func reveal():
	sprite.scale.x=0
	tween.interpolate_property(back,"scale:x",0.25,0,1,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite,"scale:x",0,0.25,1,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT,1)
	tween.start()
	yield(tween,"tween_completed")
	yield(tween,"tween_completed")
	emit_signal("revealed")
	
func conceal():
	back.scale.x = 0
	tween.interpolate_property(sprite,"scale:x",0.25,0,1,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT)
	tween.interpolate_property(back,"scale:x",0,0.25,1,Tween.TRANS_CUBIC,Tween.EASE_IN_OUT,1)
	tween.start()
	yield(tween,"tween_completed")
	yield(tween,"tween_completed")
	emit_signal("concealed")