extends Spatial

onready var ap = $Position3D/AnimationPlayer

func _on_Area_body_entered(body):
	ap.play("fall")
