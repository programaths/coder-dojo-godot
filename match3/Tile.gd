extends Area2D
class_name Match3Tile

enum DIRECTION{UP,DOWN,LEFT,RIGHT}

signal selected(target)
signal move_done(target,by_player)

onready var asprite = $AnimatedSprite
onready var left = $Left
onready var up = $Up
onready var down = $Down
onready var right = $Right
onready var tween = $Tween

var left_tile setget ,g_left_tile
var right_tile setget ,g_right_tile
var up_tile setget ,g_up_tile
var down_tile setget ,g_down_tile

var color setget ,g_color
var shape setget ,g_shape

var to_remove = false

func g_color():
	return asprite.frame%4

func g_shape():
	return asprite.frame/4

func g_left_tile():
	return left.get_collider()
	
func g_right_tile():
	return right.get_collider()
	
func g_up_tile():
	return up.get_collider()
	
func g_down_tile():
	return down.get_collider()

func _ready():
	add_to_group("tiles")
	asprite.frame = randi()%4

func _on_Area2D_input_event(_vp, event, _sid):
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT and !tween.is_active():
		emit_signal("selected",self)

func move_to(new_position:Vector2,by_player:bool):
	tween.interpolate_property(self,"position",position,new_position,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	yield(tween,"tween_completed")
	emit_signal("move_done",self,by_player)


func get_same_tiles(direction,color,shape):
	if g_color()==color: #or g_shape()==shape:
		var target = null
		match direction:
			DIRECTION.UP:
				target = g_up_tile()
			DIRECTION.LEFT:
				target = g_left_tile()
			DIRECTION.RIGHT:
				target = g_right_tile()
			DIRECTION.DOWN:
				target = g_down_tile()
		if target != null:
			var same_tiles = target.get_same_tiles(direction,color,shape)
			if same_tiles == null:
				same_tiles = []
			same_tiles.append(self)
			return same_tiles
		else:
			return [self]
	return []

func count_same(direction,color,shape):
	if g_shape()==shape or g_color()==color:
		var target = null
		match direction:
			DIRECTION.UP:
				target = g_up_tile()
			DIRECTION.LEFT:
				target = g_left_tile()
			DIRECTION.RIGHT:
				target = g_right_tile()
			DIRECTION.DOWN:
				target = g_down_tile()
		if target != null:
			return 1+target.count_same(direction,color,shape)
		else:
			return 1
	return 0
	
func remove_same(direction,color,shape):
	if g_shape()==shape or g_color()==color:
		modulate.a = 0.5
		yield(get_tree().create_timer(0.5),"timeout")
		modulate.a = 1
		var target = null
		match direction:
			DIRECTION.UP:
				target = g_up_tile()
			DIRECTION.LEFT:
				target = g_left_tile()
			DIRECTION.RIGHT:
				target = g_right_tile()
			DIRECTION.DOWN:
				target = g_down_tile()
		if target != null:
			target.remove_same(direction,color,shape)
		