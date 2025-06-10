extends Unit
class_name Villager

@export var move_speed := 50.0
@export var collect_time := 2.0

@onready var visuals: Node2D = $Visuals
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var collect_timer: Timer = $CollectTimer
@onready var collect_item: Sprite2D = %CollectItem
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

@onready var tree_weapon: Sprite2D = %TreeWeapon
@onready var rock_weapon: Sprite2D = %RockWeapon
@onready var attack_weapon: Sprite2D = %AttackWeapon

var is_carrying_item := false
var is_collecting := false
var target_tree: GameTree
var move_direction: Vector2

func _ready() -> void:
	collect_timer.wait_time = collect_time


func _process(delta: float) -> void:
	if not is_collecting and not is_carrying_item:
		move_to_tree(delta)
	
	if is_carrying_item:
		move_to_townhall(delta)
	
	update_rotation()


func move_to_tree(delta: float) -> void:
	target_tree = get_closest_tree()
	if target_tree == null: return
	
	anim_player.play("move")
	var tree_pos := target_tree.global_position
	move_to_position(tree_pos, delta)
	#var next_position := nav_agent.get_next_path_position()
	#var direction := global_position.direction_to(next_position)
	#move_direction = direction
	#position += direction * move_speed * delta

	if global_position.distance_to(target_tree.global_position) < 15:
		anim_player.play("chop")
		is_collecting = true
		collect_timer.start()


func move_to_townhall(delta: float) -> void:
	collect_item.show()
	anim_player.play("move")
	EventBus.on_chop_completed.emit(target_tree)
	target_tree = null
	
	var town := get_tree().get_first_node_in_group("townhall") as Node2D
	move_to_position(town.global_position, delta)
	
	if global_position.distance_to(town.global_position) < 30:
		anim_player.play("move")
		collect_item.hide()
		is_carrying_item = false


func move_to_position(target: Vector2, delta: float) -> void:
	nav_agent.target_position = target
	var next_position := nav_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)
	move_direction = direction
	position += direction * move_speed * delta


func update_rotation() -> void:
	if move_direction.x > 0.1:
		visuals.scale = Vector2(0.8, 0.8)
	else:
		visuals.scale = Vector2(-0.8, 0.8)


func get_closest_tree() -> GameTree:
	var tress: Array = get_tree().get_nodes_in_group("trees")
	var free_trees: Array = tress.filter(func(t: GameTree): return t.is_available)
	if not free_trees: 
		print("No avialable trees.")
		return
	
	var closest_tree = free_trees[0]
	var closest_distance := global_position.distance_to(closest_tree.global_position)
	
	for i in range(1, free_trees.size()):
		var target: GameTree = free_trees[i]
		var distance := global_position.distance_to(target.global_position)
		
		if distance < closest_distance:
			closest_tree = target
			closest_distance = distance
	return closest_tree


func trigger_chop_event() -> void:
	EventBus.on_chop_tree.emit(target_tree)


func _on_collect_timer_timeout() -> void:
	is_collecting = false
	is_carrying_item = true


func _on_detector_area_area_entered(area: Area2D) -> void:
	pass
