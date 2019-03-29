extends KinematicBody2D

var velocity = Vector2(0,0)
var can_climb = false
var climbing = false

onready var asprite = $AnimatedSprite

func _ready():
	pass # Replace with function body.

func _process(delta):
	if can_climb and Input.is_action_just_pressed("ui_up"):
		velocity = Vector2(0,0)
		climbing = true
		asprite.play("climb")
	if climbing:
		velocity = Vector2(0,0)
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			asprite.play("climb")
		if Input.is_action_pressed("ui_up"):
			velocity.y = - 196
		if Input.is_action_pressed("ui_down"):
			velocity.y = 196
		if Input.is_action_pressed("ui_left"):
			velocity.x = - 196
		if Input.is_action_pressed("ui_right"):
			velocity.x = 196
		if velocity.y ==0:
			asprite.stop()
		if Input.is_action_just_pressed("shoot"):
			velocity.y=-800
			climbing = false
			asprite.play("jump")
		move_and_slide(velocity,Vector2.UP)
	else:
		if Input.is_action_pressed("ui_right"):
			velocity.x = velocity.x + 20
		if Input.is_action_pressed("ui_left"):
			velocity.x = velocity.x - 20
			
		if is_on_floor() or is_on_ceiling():
			velocity.y = 0
			
		
		
		if Input.is_action_just_pressed("shoot") and is_on_floor():
			velocity.y=-800
			asprite.play("jump")
		
		velocity = velocity + Vector2(0,20)
		
		if velocity.x>0:
			velocity.x = velocity.x - 10
		if velocity.x<0:
			velocity.x = velocity.x + 10
		
		velocity.x = clamp(velocity.x, -512,512)
		
		if Input.is_action_just_pressed("shoot") and is_on_floor():
			move_and_slide(velocity,Vector2.UP)
		else:
			move_and_slide_with_snap(velocity,Vector2(0,10),Vector2.UP)
		if is_on_floor():
			asprite.play("walk")
			if abs(velocity.x) < 8:
				velocity.x = 0
				asprite.play("idle")
		if get_slide_count()>0:
			var col = get_slide_collision(0).collider
			if col.has_method("hit"):
				col.hit()
			
	
	asprite.flip_h = velocity.x<0
	
func enable_climbing():
	can_climb = true
	
func disable_climbing():
	can_climb = false
	climbing = false
	if asprite.animation!="jump":
		asprite.play("idle")