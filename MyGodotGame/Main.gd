extends Node2D

@onready var settings = load("res://Settings.tscn")

func _ready():
	get_viewport().size = DisplayServer.screen_get_size()
	var instance = settings.instantiate()
	add_child(instance)
