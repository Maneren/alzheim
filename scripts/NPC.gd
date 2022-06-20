extends Node2D

export(Array, String) var quests

var active_quest


func _ready():
	for quest in quests:
		if get_parent().get_parent().available_npc_quests[quest]:
			pass


func try_get_quest():
	if active_quest:
		return null

	var quest = quests.pop_at(0)

	if not quest:
		return null

	active_quest = quest

	get_parent().get_parent().start_npc_quest(quest)

	return {"id": quest, "data": get_parent().get_parent().available_npc_quests[quest]}


func try_finish_quest(quest, player):
	if quest.id != active_quest.id:
		print("Wrong quest")
		return null
