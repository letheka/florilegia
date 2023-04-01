extends Node3D

@onready var character_scene = preload("res://character.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var character = character_scene.instantiate()
	add_child(character)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
