extends Node

export(int) var max_enemy_count
export(PackedScene) var enemy_template
export(String) var spawn_name

signal enemy_killed(xp_reward, name)

var counter = 0


func _ready():
	create_enemy(0)
	counter += 1


func _on_Enemy_killed(xp_reward, name):
	emit_signal("enemy_killed", xp_reward, name)
	if counter < max_enemy_count:
		create_enemy(counter)
		counter += 1
	else:
		queue_free()


func create_enemy(i):
	var enemy = enemy_template.instance()

	var name = spawn_name + "_" + str(i)

	enemy.name = name
	enemy.position = Vector2(rand_range(-50, 50), rand_range(-50, 50))
	enemy.connect("killed", self, "_on_Enemy_killed")

	add_child(enemy)
