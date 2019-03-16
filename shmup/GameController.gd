extends Node

onready var timer = $Timer
var enemy = preload("res://shmup/Enemy1.tscn")
var choree1 = preload("res://shmup/EnemyChoree1.tscn")
var choree2 = preload("res://shmup/EnemyChoree2.tscn")
var choree3 = preload("res://shmup/EnemyChoree3.tscn")

func _ready():
	timer.start(1)

func _on_Timer_timeout():
	var rand = randf()
	if rand< 0.7:
		var new_enemy = enemy.instance()
		get_tree().root.add_child(new_enemy)
		new_enemy.global_position.x = randf()*(get_viewport().size.x*0.8)+get_viewport().size.x*0.2
		timer.start(1)
	elif rand <0.8:
		var choree = choree2.instance()
		get_tree().root.add_child(choree)
		yield(choree,"done")
		_on_Timer_timeout()
	elif rand <0.9:
		var choree = choree3.instance()
		get_tree().root.add_child(choree)
		yield(choree,"done")
		_on_Timer_timeout()
	else:
		var choree = choree1.instance()
		get_tree().root.add_child(choree)
		yield(choree,"done")
		_on_Timer_timeout()
