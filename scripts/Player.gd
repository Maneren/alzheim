extends Node2D

# Declare member variables here. Examples:
const SPEED = 350

const Cooldown = preload("res://lib/Cooldown.gd")

var attacking = false
var direction = Vector2(0, 0)
var weapon_rotation = 0

var health = 100

onready var attack_cooldown = Cooldown.new(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dx: int = 0
	var dy: int = 0

	if Input.is_action_pressed("ui_down"):
		dy += 1
	if Input.is_action_pressed("ui_up"):
		dy -= 1
	if Input.is_action_pressed("ui_left"):
		dx -= 1
	if Input.is_action_pressed("ui_right"):
		dx += 1

	var normalized = Vector2(dx, dy).normalized()

	match_sprite_direction(dx, dy)

	if dx != 0 or dy != 0:
		self.direction = normalized

	self.position += normalized * SPEED * delta

	$AttackRange.rotation = self.direction.angle()

	attack_cooldown.tick(delta)
	if Input.is_key_pressed(KEY_SPACE) and attack_cooldown.is_ready():
		print("Attack!")
		attacking = true
		$Weapon.visible = true

	if attacking:
		attack(delta)
	else:
		$Weapon.visible = false


func match_sprite_direction(dx: int, dy: int):
	print(dx, dy)

	if dx == 0 and dy == 0:
		$Texture.animation = $Texture.animation.replace("run", "stand")
	else:
		if dx == 1:
			$Texture.animation = "run_right"
		elif dx == -1:
			$Texture.animation = "run_left"
		elif dy == 1:
			$Texture.animation = "run_down"
		elif dy == -1:
			$Texture.animation = "run_up"


func attack(delta):
	weapon_rotation += TAU * delta * 2

	if weapon_rotation >= PI:
		weapon_rotation = 0
		$Weapon.visible = false
		attacking = false
		print("Done!")

	$Weapon.rotation = weapon_rotation + self.direction.angle()

	for node in get_node("AttackRange").get_overlapping_areas():
		if node.name == "EnemyArea":
			node.owner.take_damage(1, self)


func take_damage(damage, attacker):
	print("Take damage:", damage)
	self.health -= damage

	var pushback_direction = attacker.position - position

	# prevent jittery movement when close to the target
	if abs(pushback_direction.x) <= 1:
		pushback_direction.x = 0

	if abs(pushback_direction.y) <= 1:
		pushback_direction.y = 0

	var normalized = pushback_direction.normalized()

	if normalized.x != 0 or normalized.y != 0:
		direction = normalized

	var pushback = normalized * 30

	self.position -= pushback

	if self.health <= 0:
		print("Game ended!")
		self.owner.destroy()
