extends KinematicBody2D

# Declare member variables here. Examples:
const SPEED = 350

const Cooldown = preload("res://lib/Cooldown.gd")

var attacking = false
var direction = Vector2(0, 0)
var weapon_rotation = 0

var health = 100
var attack_damage = 10

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

	var movement = normalized * SPEED * delta

	if move_and_collide(movement):
		pass

	attack_cooldown.tick(delta)
	if Input.is_key_pressed(KEY_SPACE) and attack_cooldown.is_ready():
		print("Attack!")
		attacking = true
		$Weapon.visible = true

	if attacking:
		attack_tick(delta)
	else:
		$Weapon.visible = false


func match_sprite_direction(dx: int, dy: int):
	if dx == 0 and dy == 0:
		$AnimatedSprite.animation = $AnimatedSprite.animation.replace("run", "stand")
	else:
		if dx == 1:
			$AnimatedSprite.animation = "run_right"
		elif dx == -1:
			$AnimatedSprite.animation = "run_left"
		elif dy == 1:
			$AnimatedSprite.animation = "run_down"
		elif dy == -1:
			$AnimatedSprite.animation = "run_up"


func attack_tick(delta):
	weapon_rotation += TAU * delta * 2

	if weapon_rotation >= PI:
		weapon_rotation = 0
		$Weapon.visible = false
		attacking = false
		print("Done!")

	$Weapon.rotation = weapon_rotation + self.direction.angle()


func take_damage(damage):
	print("Take damage:", damage)
	self.health -= damage

	if self.health <= 0:
		self.owner.destroy()


var xp = 0


func _on_Enemies_enemy_killed(xp_reward: int, name: String):
	xp += xp_reward
	print("Killed enemy:", name, "XP:", xp_reward)
	print("Current XP:", xp)
