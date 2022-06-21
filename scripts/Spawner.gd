extends Node

export(int) var max_enemy_count
export(PackedScene) var enemy_template
export(int) var enemy_spawn_interval = 1

signal enemy_killed(xp_reward, name)


func _ready():
	$Timer.wait_time = enemy_spawn_interval
	create_enemy(1)


func _on_Enemy_killed(xp_reward, name):
	emit_signal("enemy_killed", xp_reward, name)


func _on_Timer_timeout():
	var child_count = get_child_count() - 1  # one child is the Timer

	if child_count >= max_enemy_count:
		return

	create_enemy(child_count)


func create_enemy(i):
	var enemy = enemy_template.instance()

	var name = "Enemy_" + str(i)
	enemy.name = name
	enemy.position = Vector2(rand_range(-50, 50), rand_range(-50, 50))
	enemy.connect("killed", self, "_on_Enemy_killed")

	add_child(enemy)
