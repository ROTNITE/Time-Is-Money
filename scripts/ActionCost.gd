# scripts/ActionCost.gd — универсальный компонент "стоимость действия"
extends Node
class_name ActionCost

## Базовая стоимость в секундах (можно переопределить при вызове pay()).
@export var default_cost: float = 1.0
## Разрешать ли уходить в минус? Обычно НЕТ.
@export var allow_negative: bool = false

## Пытается списать 'cost' секунд (или default_cost, если не задано).
## Возвращает true при успехе, false если времени недостаточно.
func pay(cost: float = -1.0) -> bool:
	if cost < 0.0:
		cost = default_cost
	if cost <= 0.0:
		return true  # Нулевая/отрицательная цена — «бесплатно».
	if not allow_negative and Game.time_left < cost:
		return false
	Game.spend_time(cost)
	return true
