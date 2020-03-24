extends Sprite

func _ready() -> void:
	$Timer.start()

func _on_Timer_timeout() -> void:
	queue_free()
