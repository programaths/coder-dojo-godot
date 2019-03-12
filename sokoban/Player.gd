extends KinematicBody2D

onready var tween = $Tween

var start=null 
var end = null
var t=0

func try_move(delta,rel_vec:Vector2):
	var other = move_and_collide(rel_vec,true,true,true)
	if other!=null:
		if other.collider.has_method("move"):
			var blocking_object=other.collider.move(rel_vec)
			if blocking_object==null:
				tween.interpolate_property(self,"position",position,position+rel_vec,0.25,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
				tween.start()
			else:
				print("blocked")
	else:
		t=0
		start=position
		end=position+rel_vec

func _process(delta):
	if tween.is_active():return
	if end!=null:
		t=t+delta*10
		position = lerp(start,end,t)
		if(t>1):
			position = end
			end = null
		return
	if Input.is_action_pressed("ui_up"):
		try_move(delta,Vector2(0,-64))
		return
	if Input.is_action_pressed("ui_down"):
		try_move(delta,Vector2(0,64))
		return
	if Input.is_action_pressed("ui_left"):
		try_move(delta,Vector2(-64,0))
		return
	if Input.is_action_pressed("ui_right"):
		try_move(delta,Vector2(64,0))
		return