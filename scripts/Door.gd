# scripts/Door.gd — дверь: платная ручная активация ИЛИ реакция на кнопку
extends Node2D
class_name Door

@export var open_cost: float = 10.0
@export var starts_closed: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _is_open := false
var _action_cost: ActionCost

func _ready() -> void:
	_action_cost = get_node_or_null(ActionCost) as ActionCost
	if _action_cost == null:
		_action_cost = ActionCost.new()
		add_child(_action_cost)
	_action_cost.default_cost = open_cost

	if not starts_closed:
		_open_visual()

func try_open() -> void:
	if _is_open:
		return
	if _action_cost.pay(open_cost):
		_open_visual()

func _open_visual() -> void:
	_is_open = true
	if animation_player and animation_player.has_animation("open"):
		animation_player.play("open")
