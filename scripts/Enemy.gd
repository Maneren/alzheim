extends KinematicBody2D
signal killed(xp_reward, name)

# Declare member variables here. Examples:
const SPEED = 300

const Cooldown = preload("res://lib/Cooldown.gd")

var attacking = false
var direction = Vector2(0, 0)
var weapon_rotation = 0

onready var attack_cooldown = Cooldown.new(1.5)

var xp_reward: int
var health: int
var attack_damage: int


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attack_cooldown.tick(delta)

	var moving_to_player = false

	for node in $SearchRange.get_overlapping_bodies():
		if node.name == "Player" and (node.position - get_parent().position).length() < 1000:
			move_to_node(delta, node)
			moving_to_player = true
			break

	if not moving_to_player:
		move_to_node(delta / 2, get_parent())

	for node in $AttackRange.get_overlapping_bodies():
		if node.name == "Player":
			if attack_cooldown.is_ready():
				print("Enemy attack!")
				attacking = true
				$Weapon.visible = true

			break

	if attacking:
		attack_tick(delta)
	else:
		$Weapon.visible = false


func move_to_node(delta, player):
	var looking_direction = player.position - (get_parent().position + position)

	# prevent jittery movement when close to the target
	if abs(looking_direction.x) <= 1 and abs(looking_direction.y) <= 1:
		return

	# keep distance from target
	if looking_direction.length() < 90:
		return

	var normalized = looking_direction.normalized()

	if normalized.x != 0 or normalized.y != 0:
		direction = normalized

	var movement = normalized * SPEED * delta

	if move_and_collide(movement):
		pass


func attack_tick(delta):
	weapon_rotation += TAU * delta * 2.5

	if weapon_rotation >= PI:
		weapon_rotation = 0
		$Weapon.visible = false
		attacking = false
		print("Done!")

	$Weapon.rotation = weapon_rotation + self.direction.angle()


func take_damage(damage):
	print("Enemy take damage:", damage)
	self.health -= damage

	if self.health <= 0:
		emit_signal("killed", xp_reward, name)
		queue_free()
