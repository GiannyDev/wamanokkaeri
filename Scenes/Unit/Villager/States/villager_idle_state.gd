extends VillagerState
class_name VillagerIdleState

func enter_state() -> void:
	villager.anim_player.play("idle")
	print("running")

func run_state() -> void:
	pass

func exit_state() -> void:
	pass
