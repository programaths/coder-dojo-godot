extends KinematicBody2D

var vel : Vector2 = Vector2(0,0)
var accell = 512
var damping = 64


var weapon : PackedScene = preload("res://shmup/Lazer.tscn")

var can_shoot = true

var shot_per_second = 3

onready var muzzle = $Muzzle

func _ready():
	pass


func _process(delta):
	if Input.is_action_pressed("ui_left"):
		vel.x = vel.x - accell*delta
		if vel.x > 0: vel.x = vel.x - accell*delta
	if Input.is_action_pressed("ui_right"):
		vel.x = vel.x + accell*delta
		if vel.x <0: vel.x = vel.x + accell*delta
	if Input.is_action_pressed("ui_up"):
		vel.y = vel.y - accell*delta
		if vel.y>0:vel.y = vel.y - accell*delta
	if Input.is_action_pressed("ui_down"):
		vel.y = vel.y + accell*delta
		if vel.y<0: vel.y = vel.y + accell*delta
	
	vel.y = vel.y - sign(vel.y)*damping*delta
	vel.x = vel.x - sign(vel.x)*damping*delta
	
	if Input.is_action_pressed("shoot") and can_shoot and shot_per_second>0:
		can_shoot = false
		var lazer : Node2D = weapon.instance()
		get_tree().root.add_child(lazer)
		lazer.global_position = muzzle.global_position + vel*delta*2
		yield(get_tree().create_timer(1.0/shot_per_second),"timeout")
		can_shoot = true

	move_and_slide(vel)