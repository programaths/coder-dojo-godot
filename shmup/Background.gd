extends Sprite

var scroll_speed = 64


func _ready():
	pass # Replace with function body.


func _process(delta):
	region_rect.position.y = region_rect.position.y - scroll_speed*delta
