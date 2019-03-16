extends KinematicBody2D



func _process(delta):
	move_and_slide(Vector2(0,128))

func hit(n):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
