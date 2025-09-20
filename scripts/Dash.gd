# scripts/Dash.gd — пример: рывок с ценой "dash_cost"
extends Node

@export var dash_cost: float = 2.0
@export var dash_speed: float = 600.0
@export var dash_time: float = 0.12

var _owner_body: CharacterBody2D
var _action_cost: ActionCost
var _dashing := false
var _dash_dir := Vector2.ZERO
var _dash_timer := 0.0

func _ready() -> void:
	_owner_body = owner as CharacterBody2D
	_action_cost = get_node_or_null(ActionCost) as ActionCost
	if _action_cost == null:
		_action_cost = ActionCost.new()
		add_child(_action_cost)

func _process(delta: float) -> void:
	if _dashing:
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			_dashing = false

func try_dash(dir: Vector2) -> void:
	if _dashing or dir == Vector2.ZERO:
		return
	if _action_cost.pay(dash_cost):
		_dashing = true
		_dash_dir = dir.normalized()
		_dash_timer = dash_time

func apply_to_velocity(base_velocity: Vector2) -> Vector2:
	if _dashing:
		return _dash_dir * dash_speed
	return base_velocity
