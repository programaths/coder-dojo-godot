extends Node2D

onready var winner_dialog = $WinnerDialog

func _ready():
	for p in get_tree().get_nodes_in_group("pentominos"):
		p.connect("mouse_enter",self,"add_candidate")
		p.connect("mouse_leave",self,"remove_candidate")
		
var candidates = []

var current_grab = null



func _input(event):
	if event is InputEventMouseButton and event.button_index==BUTTON_RIGHT and event.is_pressed() and current_grab:
		current_grab.rotate(PI/2)
	if event is InputEventMouseButton and event.button_index==BUTTON_LEFT:
		if current_grab:
			current_grab.release()
			current_grab.position = current_grab.position.snapped(Vector2(32,32))
			current_grab = null
		if !candidates.empty() and event.is_pressed():
			candidates.sort_custom(self,"sort_candidates")
			var topmost = candidates.front()
			topmost.raise()
			current_grab = topmost
			topmost.grab(event.global_position-topmost.global_position)
		if !event.is_pressed():
			var ok = true
			for detector in get_tree().get_nodes_in_group("detectors"):
				if !detector.is_satisfied():
					ok = false
					break
			if ok:
				winner_dialog.popup()

func sort_candidates(a,b):
	return a.get_index() > b.get_index()

func add_candidate(target):
	print("add")
	candidates.append(target)

func remove_candidate(target):
	print("remove")
	candidates.erase(target)
		

