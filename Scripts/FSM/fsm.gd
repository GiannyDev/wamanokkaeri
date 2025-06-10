extends Node
class_name FSM

@export var init_state: FSMState
@export var villager: Villager

enum States {
	IDLE,
	MOVING,
	COLLECTING,
	CARRYING,
	FIGHTING,
	DEAD
}

var current_state: FSMState
var game_states: Dictionary[States, Node] = { }

func _ready() -> void:
	EventBus.on_change_state.connect(_on_change_state)
	for state: VillagerState in get_children():
		game_states[state.state_type] = state
		state.villager = villager


func run_state() -> void:
	if not current_state: return
	current_state.run_state()


func change_state(new_state: FSMState) -> void:
	if current_state == new_state:
		return
	
	if current_state:
		current_state.exit_state()
	
	current_state = new_state
	current_state.enter_state()


func _on_change_state(new_state: States) -> void:
	var state: FSMState = game_states[new_state]
	if state:
		change_state(state)
