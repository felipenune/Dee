extends Light2D

onready var player = get_parent().get_node("Animations")
export var light_color = []

func _ready() -> void:
	print(player.state_dl)


func _process(delta: float) -> void:
	if player.state_dl == "dark":
		color = light_color[0]
	elif player.state_dl == "light":
		color = light_color[1]
