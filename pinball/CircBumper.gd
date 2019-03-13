extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CircBumper_body_entered(body:Ball):
	if body!=null:
		self_modulate=Color(0.8,0.8,0.8)
		yield(get_tree().create_timer(0.2),"timeout")
		self_modulate=Color(1,1,1)
