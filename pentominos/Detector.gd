extends Area2D

var nb_pieces = 0

func _ready():
	add_to_group("detectors")

func _on_Detector_area_entered(area):
	nb_pieces = nb_pieces + 1

func _on_Detector_area_exited(area):
	nb_pieces = nb_pieces - 1

func is_satisfied():
	return nb_pieces == 1