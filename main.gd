extends Node2D


func _ready():
	load_game()


func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_F5:
		save_game()


func load_game():
	var save_data = load_file()
	if not save_data:
		return

	var json = JSON.parse(save_data)

	if json.error:
		print("Error loading game: " + json.error)
		return

	var data = json["result"]

	var player = data["player"]
	var enemies = data["enemies"]

	player["active_npc_quests"] = {}
	for quest in player["active_npc_quests_names"]:
		player["active_npc_quests"][quest] = $QuestGivers.available_npc_quests[quest]

	player["active_bard_quests"] = {}
	for quest in player["active_bard_quests_names"]:
		player["active_bard_quests"][quest] = $QuestGivers.available_bard_quests[quest]

	$Player.load_save_data(player)


func save_game():
	var data = {}

	data["player"] = $Player.get_save_data()
	data["enemies"] = $Enemies.get_save_data()

	var json = JSON.print(data, "  ")
	save_file(json)


func save_file(content):
	var file = File.new()
	file.open("user://save_game.dat", File.WRITE)
	file.store_string(content)
	print("Wrote save file")
	file.close()


func load_file():
	var file = File.new()
	var err = file.open("user://save_game.dat", File.READ)
	if err:
		return null

	var content = file.get_as_text()
	file.close()
	return content
