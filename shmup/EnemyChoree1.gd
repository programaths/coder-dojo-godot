extends Node2D

var enemy = preload("res://shmup/EnemyPathFolower.tscn")

onready var path_left = $PathLeftLoop
onready var path_right = $PathRightLoop

signal done

var nb_destroyed = 0

func _ready():
	for i in range(5):
		var enemy_left = enemy.instance()
		path_left.add_child(enemy_left)
		enemy_left.connect("tree_exited",self,"count_destroyed")
		var enemy_right = enemy.instance()
		path_right.add_child(enemy_right)
		enemy_right.connect("tree_exited",self,"count_destroyed")
		yield(get_tree().create_timer(1),"timeout")

func count_destroyed():
	nb_destroyed = nb_destroyed + 1
	if nb_destroyed>=10:
		emit_signal("done")
		queue_free()