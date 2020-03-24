extends Sprite

export var tween_duration: float
var color

func _ready() -> void:
	$Tween_alpha.interpolate_property(self, "modulate",
	Color(1,1,1,1), Color(1,1,1,0), tween_duration, Tween.EASE_IN)
	$Tween_alpha.start()

	var player = get_parent().get_node("Player")
	var player_animations = player.get_node("Animations")
	var player_frames = player_animations.get_node("AnimatedSprite")
	
	texture = player_frames.frames.get_frame(
		player_frames.animation, player_frames.frame)
		
	if player_animations.state_dl == "dark":
		color = player.shadow_color[0]
	else:
		color = player.shadow_color[1]
		
	material.set("shader_param/TextureUniform", texture)
	material.set("shader_param/ColorUniform", color)


func _on_Tween_alpha_tween_completed() -> void:
	queue_free()
