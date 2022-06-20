extends Node2D

signal enemy_killed(xp_reward, name)


func _on_Spawner_enemy_killed(xp_reward, name):
	breakpoint
	emit_signal("enemy_killed", xp_reward, name)


func _ready():
	for child in get_children():
		if child.name.begins_with("Spawner"):
			child.connect("enemy_killed", self, "_on_Spawner_enemy_killed")
			print("Connected to Spawner")
