# scripts/InteractableButton.gd — кнопка: при интеракции списывает 3с и шлёт сигнал "activated"
extends Area2D
class_name InteractableButton

signal activated  # Удачное нажатие после списания времени

@export var interact_cost: float = 3.0
@export var one_shot: bool = false

var _used := false
var _action_cost: ActionCost

func _ready() -> void:
	_action_cost = get_node_or_null(ActionCost) as ActionCost
	if _action_cost == null:
		_action_cost = ActionCost.new()
		add_child(_action_cost)
	_action_cost.default_cost = interact_cost

func try_interact() -> void:
	if _used and one_shot:
		return
	if _action_cost.pay(interact_cost):
		_used = true
		emit_signal("activated")
