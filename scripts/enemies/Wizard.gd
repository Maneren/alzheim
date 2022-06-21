extends "../Enemy.gd"


func _process(delta):
	attack_cooldown.tick(delta)

	for node in $SearchRange.get_overlapping_bodies():
		if node.name == "Player":
			move_to_node(delta, node)
			break

	for node in $AttackRange.get_overlapping_bodies():
		if node.name == "Player":
			if first_attack:
				first_attack = false
				attack_cooldown.reset_with_delay(1)
			if attack_cooldown.is_ready():
				print("Enemy attack!")
				attacking = true
				$Weapon.visible = true

			break

	if attacking:
		attack_tick(delta)
	else:
		$Weapon.visible = false


func match_sprite_direction(_vec: Vector2):
	pass
