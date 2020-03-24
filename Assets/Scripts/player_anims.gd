extends Node2D

var state_dl = "dark"
export var dissolve_amount_dark = 0.5
export var dissolve_amount_light = 0.5

var texture_dark
var dissolving_dark

var texture_light
var dissolving_light

onready var player = get_parent()
onready var dark = $AnimatedSprite
onready var light = $LightAnimation

func _process(delta: float) -> void:
	
	light.animation = dark.animation
	light.frame = dark.frame
	light.position = dark.position
	
	if player.is_on_floor():
		if player.walk_left or player.walk_right:
			dark.animation = "walk"
		else:
			dark.animation = "idle"
	else:
		dark.animation = "idle"
#
#-----------------------------------------------------------------
#-----------------------------------------------------------------
#-----------------------------------------------------------------
#-----------------------------------------------------------------
#
# Dissolve Effect
	texture_dark = dark.frames.get_frame(dark.animation, dark.frame)
	dark.material.set("shader_param/TextureUniform", texture_dark)
	
	texture_light = light.frames.get_frame(light.animation, light.frame)
	light.material.set("shader_param/TextureUniform", texture_light)

	dark.material.set("shader_param/ScalarUniform", dissolve_amount_dark)
	light.material.set("shader_param/ScalarUniform", dissolve_amount_light)
	
	if Input.is_action_just_pressed("ui_transform") and state_dl == "dark":
		dissolving_dark = true
		state_dl = "light"
		light.visible = true
	elif Input.is_action_just_pressed("ui_transform") and state_dl == "light":
		dissolving_light = true
		state_dl = "dark"
		dark.visible = true
	
	if dissolving_dark:
		dissolve_amount_dark -= delta * 3
	elif dissolving_light:
		dissolve_amount_light -= delta * 3
		
	if dissolve_amount_dark < -0.5:
		dark.z_index = -1
		light.z_index = 0
		dissolve_amount_dark = 0.5
		dissolving_dark = false
		dark.visible = false
	
	elif dissolve_amount_light < -0.5:
		light.z_index = -1
		dark.z_index = 0
		dissolve_amount_light = 0.5
		dissolving_light = false
		light.visible = false
