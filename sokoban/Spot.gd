extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Spot_body_entered(body:Crate):
	if body!=null:
		body.set_placed(true)


func _on_Spot_body_exited(body:Crate):
	if body!=null:
		body.set_placed(false)
