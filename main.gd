extends Node2D

onready var viewport = get_viewport()

var base = 0.8
var scl
var resolution = 720


func _ready():
	viewport.connect("size_changed", self, "window_resize")
	window_resize()

	load_game()


func window_resize():
	scl = base * (OS.window_size.y / resolution)
	self.scale.x = scl
	self.scale.y = scl


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F5:
			save_game()

		elif event.scancode == KEY_F8:
			delete_file()


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
		player["active_npc_quests"][quest] = $QuestGivers.available_quests[quest]

	player["active_bard_quests"] = {}
	for quest in player["active_bard_quests_names"]:
		player["active_bard_quests"][quest] = $QuestGivers.available_quests[quest]

	$Player.load_save_data(player)
	$Enemies.load_save_data(enemies)


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


func delete_file():
	var dir = Directory.new()
	dir.remove("user://save_game.dat")
	print("Deleted save file")
