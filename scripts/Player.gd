extends Node2D

# Declare member variables here. Examples:
const SPEED = 350

const Cooldown = preload("res://lib/Cooldown.gd")

var attacking = false
var direction = Vector2(0, 0)
var weapon_rotation = 0

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

	if dx != 0 or dy != 0:
		self.direction = Vector2(dx, dy).normalized()
	self.position += Vector2(dx, dy).normalized() * SPEED * delta

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


func attack(delta):
	print(weapon_rotation, "+", self.direction.angle(), "=", $Weapon.rotation)
	weapon_rotation += TAU * delta * 4
	print(weapon_rotation, "+", self.direction.angle(), "=", $Weapon.rotation)

	if weapon_rotation >= PI:
		weapon_rotation = 0
		$Weapon.visible = false
		attacking = false
		print("Done!")

	$Weapon.rotation = weapon_rotation + self.direction.angle()

	# for node in get_node("AttackRange").get_overlapping_areas():
	# 	if node.name == "EnemyArea":
	# 		node.owner.take_damage(1)
