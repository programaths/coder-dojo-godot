extends Node2D

var enemy = preload("res://shmup/EnemyPathFolower.tscn")
var spr = preload("res://shmup/sprites/Enemies/enemyRed1.png")

onready var path = $PathLeftS


signal done

var nb_destroyed = 0

func _ready():
	for i in range(10):
		var enemy_left = enemy.instance()
		path.add_child(enemy_left)
		enemy_left.find_node("Sprite").texture = spr
		enemy_left.connect("tree_exited",self,"count_destroyed")
		yield(get_tree().create_timer(0.5),"timeout")

func count_destroyed():
	nb_destroyed = nb_destroyed + 1
	if nb_destroyed>=10:
		emit_signal("done")
		queue_free()