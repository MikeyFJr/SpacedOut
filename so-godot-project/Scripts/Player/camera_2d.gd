extends Camera2D

var default_zoom = Vector2(4,4)
var zoom_out = Vector2(3.5,3.5)
#var look_ahead_x = 10 wanted to change it to general camera movement depending on which ur facing and if you have a velocity x, but might not get to it

var look_ahead_y_fall = 10
var look_ahead_x_fall = 10

func update_camera(player_velocity:Vector2):
	if player_velocity.y > 0 : #if falling
		#use the zoom out and look down a lil bit
		zoom = zoom.lerp(zoom_out,0.1)
		offset.y = lerp(offset.y,look_ahead_y_fall+ 0.0,0.1)
		offset.x = lerp(offset.x,look_ahead_x_fall+ 0.0,0.1)
	else:
		#change back
		zoom = zoom.lerp(default_zoom,0.1)
		offset.y =  lerp(offset.y,0.0 ,0.1)
