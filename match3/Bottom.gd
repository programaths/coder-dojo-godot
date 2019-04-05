extends Area2D

var tile: Match3Tile

func _ready():
	add_to_group("bottoms")

func _on_Bottom_area_entered(area:Match3Tile):
	if area!=null:
		tile = area

func _on_Bottom_area_exited(area):
	if area == tile:
		tile = null
