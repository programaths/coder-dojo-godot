extends StaticBody2D

onready var anim_player = $AnimationPlayer
onready var spr = $AnimatedSprite

var bonus = preload("res://platformer/Bonus.tscn")
var new_bonus

func _ready():
	pass # Replace with function body.

func hit():
	anim_player.play("hit")
	
func emit_bonus():
	if spr.animation == "default":
		new_bonus = bonus.instance()
		get_tree().root.add_child(new_bonus)
		new_bonus.global_position = global_position
	
func destroy_bonus():
	if spr.animation == "default":
		spr.play("hit")
		new_bonus.queue_free()