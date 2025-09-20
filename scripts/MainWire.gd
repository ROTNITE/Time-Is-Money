# scripts/MainWire.gd — опционально, если хотите делать соединения программно
extends Node

@onready var button := $"World/Button"
@onready var door := $"World/Door"

func _ready() -> void:
	button.activated.connect(door.try_open)
