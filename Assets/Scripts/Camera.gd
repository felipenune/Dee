extends Node2D

onready var player = get_parent().get_node("Player")
var player_pos

var shaking = false
var rand_generate = RandomNumberGenerator.new()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	#Camera Positions
	player_pos = player.position
	if player_pos.x > position.x + 320:
		position.x += 640
	if player_pos.x < position.x - 320:
		position.x -= 640
	if player_pos.y > position.y + 180:
		position.y += 360
	if player_pos.y < position.y - 180:
		position.y -= 360
		
	#Camera Shake
	if player.has_dash and not shaking:
		var rand_shake = rand_generate.randi_range(1,3)
		shaking = true
		$AnimationPlayer.play("Shake" + str(rand_shake))
	if not player.has_dash:
		shaking = false
