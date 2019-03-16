extends KinematicBody2D

var speed = 512

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var coll = move_and_collide(Vector2(0,-speed*delta))
	if coll!=null:
		if coll.collider.has_method("hit"):
			coll.collider.hit(10)
			queue_free()
		if coll.collider.get_parent().has_method("hit"):
			coll.collider.get_parent().hit(10)
			queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
