extends Node2D
class_name GameTree

const TREE_CHOP = preload("uid://c7eset3reeyqg")
const TINY_TOWN = preload("uid://dcu0vuh4lc8lb")

@onready var regen_timer: Timer = $RegenTimer
@onready var sprite: Sprite2D = $Sprite

var is_available := true

func _ready() -> void:
	EventBus.on_chop_tree.connect(_on_chop_tree)
	EventBus.on_chop_completed.connect(_on_chop_completed)


func update_empty_sprite() -> void:
	sprite.texture = TREE_CHOP
	sprite.region_enabled = false
	sprite.position.y = -8


func update_full_sprite() -> void:
	sprite.texture = TINY_TOWN
	sprite.position.y = -15
	sprite.region_enabled = true
	sprite.region_rect = Rect2(64, 0, 15, 31)
	Springer.squash(sprite, -0.4, 0.4, 1, 250, 12)
	Springer.rotate(sprite, 7)


func _on_chop_tree(tree: GameTree) -> void:
	if tree != self: return
	Springer.squash(sprite, -0.4, 0.4, 1, 250, 12)
	sprite.material = GameManager.FLASH_MATERIAL
	await get_tree().create_timer(0.1).timeout
	sprite.material = null


func _on_chop_completed(tree: GameTree) -> void:
	if tree != self: return
	regen_timer.start()
	update_empty_sprite()


func _on_regen_timer_timeout() -> void:
	is_available = true
	update_full_sprite()
