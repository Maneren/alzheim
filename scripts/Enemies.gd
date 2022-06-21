extends Node2D

signal enemy_killed(xp_reward, name)


func _on_Spawner_enemy_killed(xp_reward, name):
	emit_signal("enemy_killed", xp_reward, name)


func _ready():
	for child in get_children():
		if child.name.begins_with("Spawner"):
			child.connect("enemy_killed", self, "_on_Spawner_enemy_killed")


func get_save_data():
	var data = {}
	for child in get_children():
		print(child.name)
		if child.name.begins_with("Single"):
			print(JSON.print(child))
			# data[child.name.split(":")[1]] = JSON.print(child)

	print(data)
	return data


func load_save_data(data):
	for id in data:
		var child_json = data[id]

		var err = JSON.parse(child_json)

		if err:
			print("Error loading quest: " + id)
			print(err)
			continue

		add_child(err.result)
