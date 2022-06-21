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
			var child_data = {"counter": child.counter - 1}
			data[child.spawn_name] = child_data

	print(data)
	return data


func load_save_data(data):
	for id in data:
		var quest_data = data[id]

		var quest_givers = get_node("/root/Game/QuestGivers")
		var quest = quest_givers.available_quests[id]
		var spawner = load("res://scenes/SingleSpawner.tscn").instance()

		spawner.name = "quest:" + id
		spawner.max_enemy_count = quest.amount
		spawner.enemy_template = load("res://scenes/enemies/" + quest.target + ".tscn")
		spawner.spawn_name = id
		var x = quest.coords[0]
		var y = quest.coords[1]
		spawner.position = Vector2(x, y) * 128
		spawner.connect("enemy_killed", self, "_on_Spawner_enemy_killed")

		spawner.counter = quest_data["counter"]

		self.add_child(spawner)

	print(get_children())
	breakpoint
