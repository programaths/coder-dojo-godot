extends PathFollow2D

var speed = 512



func _ready():
	pass


func _process(delta):
	offset = offset + speed * delta
	
func hit(n):
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
