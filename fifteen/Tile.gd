tool
extends KinematicBody2D

onready var tween = $Tween
onready var sprite = $Sprite

export(String,"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P") onready var letter setget s_letter

func _on_Tile_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==BUTTON_LEFT:
		if try_move(Vector2.RIGHT*128): return
		if try_move(Vector2.DOWN*128): return
		if try_move(Vector2.LEFT*128): return
		if try_move(Vector2.UP*128): return

func try_move(rel_vec):
	print("trying", rel_vec)
	if test_move(transform,rel_vec): return false
	tween.interpolate_property(self,"position",position,position+rel_vec,0.25,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	return true
	
func s_letter(l):
	letter = l
	call_deferred("update_letter",l)
	
func update_letter(l):
	sprite.play(l)