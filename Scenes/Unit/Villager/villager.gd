extends Unit
class_name Villager

@onready var fsm: FSM = $FSM
@onready var visuals: Node2D = $Visuals

func _process(delta: float) -> void:
	pass


func get_closest_resource() -> Node2D:
	return null
