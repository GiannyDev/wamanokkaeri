extends Sprite2D

@export var imagenes: Array [Texture2D]

func _ready() -> void:
	texture = imagenes.pick_random()
