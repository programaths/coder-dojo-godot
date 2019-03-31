extends RigidBody2D

var hits = []

var can_hit = false

func _ready():
	pass


func _on_RigidBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index==BUTTON_LEFT:
		pass
		

func _physics_process(delta):
	
	var expected_path = (global_position - get_global_mouse_position())*2
	var distance_remaining = expected_path.length()
	
	hits.clear()
	var previous_position = global_position
	var exp_position = previous_position+expected_path
	var wall = get_world_2d().direct_space_state.intersect_ray(previous_position,previous_position+expected_path,[self])
	var nb =0
	
	while !wall.empty() and distance_remaining>0 and nb<4:
		var new_position = wall.position
		hits.append(wall)
		distance_remaining = distance_remaining - previous_position.distance_to(new_position)
		expected_path=expected_path.bounce(wall.normal)
		expected_path=expected_path.normalized()*distance_remaining
		wall = get_world_2d().direct_space_state.intersect_ray(new_position+expected_path.normalized(),new_position+expected_path,[self])
		nb=nb+1
	update()
	
	if Input.is_action_just_pressed("golf") and can_hit:
		apply_central_impulse( (global_position-get_global_mouse_position())*2)
		
	can_hit =abs(linear_velocity.x) < 1 and abs(linear_velocity.y)<1
		

func _draw():
	if !can_hit:return
	
	draw_set_transform(Vector2(0,0),0,Vector2(1,1))
	for hit in hits:
		draw_circle(hit.position-global_position,8.0,Color.red)
	
	draw_set_transform(Vector2(0,0), get_global_mouse_position().angle_to_point(global_position),Vector2(1,1))
	draw_rect(Rect2(0,0,global_position.distance_to(get_global_mouse_position()),4),ColorN("red"))
	var last_pos = Vector2(0,0)
	draw_set_transform(Vector2(0,0), 0,Vector2(1,1))
	for hit in hits:
#		draw_set_transform( last_pos, hit.position.angle_to(global_position),Vector2(1,1))
		draw_circle(Vector2(0,0),8.0,Color.pink)
		draw_line(last_pos,hit.position - global_position,Color.pink,4.0)
		last_pos = hit.position - global_position