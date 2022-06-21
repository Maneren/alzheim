extends Node2D

export(String) var quest

var active_quest


func _ready():
	if get_parent().get_parent().available_bard_quests[quest]:
		pass


func try_get_quest():
	if active_quest:
		return null

	active_quest = quest

	get_parent().get_parent().start_bard_quest(quest)

	return {"id": quest, "data": get_parent().get_parent().available_bard_quests[quest]}


func try_finish_quest():
	if not active_quest:
		return null

	active_quest = null

	return true
