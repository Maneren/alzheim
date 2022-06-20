extends Node2D

# Declare member variables here. Examples:
const SPEED = 300

const Cooldown = preload("res://lib/Cooldown.gd")

var attacking = false
var direction = Vector2(0, 0)
var weapon_rotation = 0

onready var attack_cooldown = Cooldown.new(1.5)

var health = 10
var attack_damage = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attack_cooldown.tick(delta)

	for node in $SearchRange.get_overlapping_areas():
		if node.name == "HitBox" and node.owner.name == "Player":
			move_to_player(delta, node.owner)
			break

	for node in $AttackRange.get_overlapping_areas():
		if node.name == "HitBox" and node.owner.name == "Player":
			if attack_cooldown.is_ready():
				print("Enemy attack!")
				attacking = true
				$Weapon.visible = true

			break

	if attacking:
		attack_tick(delta)
	else:
		$Weapon.visible = false


func move_to_player(delta, player):
	var looking_direction = player.position - position

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

	position += movement


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
		self.owner.destroy()
