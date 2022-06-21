extends KinematicBody2D

signal village_entered(name)

# Declare member variables here. Examples:
const SPEED = 350

const Cooldown = preload("res://lib/Cooldown.gd")

var attacking = false
var direction = Vector2(0, 0)
var weapon_rotation = 0

var max_health = 100
var health = 100
var xp = 0

var attack_damage = 10

onready var attack_cooldown = Cooldown.new(1)

var active_npc_quests = {}
var active_bard_quests = {}

var quest_counter = 0

var finished_npc_quests = []
var finished_bard_quests = []

onready var HP_LABEL = get_node("/root/Game/Player/Camera2D/HUD/HP")
onready var XP_LABEL = get_node("/root/Game/Player/Camera2D/HUD/XP")
onready var QUEST_LABEL = get_node("/root/Game/Player/Camera2D/HUD/quest")


func _ready():
	HP_LABEL.text = str(health)
	XP_LABEL.text = str(xp)


func set_health(new_health: int):
	self.health = new_health
	HP_LABEL.text = str(health)


func set_xp(new_xp: int):
	self.xp = new_xp
	XP_LABEL.text = str(xp)


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

	var collision
	if QUEST_LABEL.text == "":
		collision = move_and_collide(movement)

	if collision and collision.collider.name == "StaticBodyTavern":
		set_health(min(health + 1, max_health))

	attack_cooldown.tick(delta)
	if Input.is_key_pressed(KEY_SPACE) and attack_cooldown.is_ready():
		attacking = true
		$PlayerAttack.play()
		$Weapon.visible = true

	if attacking:
		attack_tick(delta)
	else:
		$Weapon.visible = false


func match_sprite_direction(dx: int, dy: int):
	if dx == 0 and dy == 0:
		#$PlayerRun.stop()
		$AnimatedSprite.animation = $AnimatedSprite.animation.replace("run", "stand")
	else:
		#$PlayerRun.play()
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

	$Weapon.rotation = weapon_rotation + self.direction.angle()


func take_damage(damage, name):
	print("Player takes damage:", damage, "from", name)
	set_health(health - damage)
	$PlayerHurt.play()

	if self.health <= 0:
		die()


func die():
	var taverns = [
		Vector2(53, 68) * 128,
		Vector2(137, 68) * 128,
		Vector2(40, 147) * 128,
		Vector2(159, 157) * 128
	]

	var closest
	var closest_distance = 100000000

	for tavern in taverns:
		var dist = (tavern - self.position).length()
		if dist < closest_distance:
			closest = tavern
			closest_distance = dist

	self.position = closest
	set_health(max_health)


func _on_Enemies_enemy_killed(xp_reward: int, name: String):
	set_xp(xp + xp_reward)
	print("Killed enemy:", name, "XP:", xp_reward)
	print("Current XP:", xp)

	for id in active_npc_quests:
		var quest = active_npc_quests[id]

		if name.begins_with(id):
			self.quest_counter += 1
			if self.quest_counter >= quest.amount:
				print("Quest complete:", id)
				set_xp(xp + quest.xp)
				self.finished_npc_quests.append(id)
				self.active_npc_quests.erase(id)

				quest_counter = 0

			print(self.quest_counter, "of", quest.amount, "enemies killed")
		break

	for id in active_bard_quests:
		var quest = active_bard_quests[id]

		if name.begins_with(id):
			self.quest_counter += 1
			if self.quest_counter >= quest.amount:
				print("Quest complete:", id)
				set_xp(xp + quest.xp)
				self.finished_bard_quests.append(id)
				self.active_bard_quests.erase(id)

				quest_counter = 0

			print(self.quest_counter, "of", quest.amount, "enemies killed")
		break


func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ENTER and QUEST_LABEL.text != "":
			QUEST_LABEL.text = ""
		elif event.scancode == KEY_E:
			get_quest()


func get_quest():
	for node in $InteractionArea.get_overlapping_areas():
		var npc = node.owner

		print("NPC:", npc.name)

		if npc.name.begins_with("NPC"):
			print("Talk to NPC")

			if npc.active_quest in self.active_npc_quests.keys():
				print("Already talked to this NPC")
				QUEST_LABEL.text = self.active_npc_quests[npc.active_quest].description
			else:
				var quest = npc.try_get_quest()
				if quest:
					self.active_npc_quests[quest.id] = quest.data
					QUEST_LABEL.text = quest.data.description
				else:
					QUEST_LABEL.text = "I don't have any quests for you"
					print("No quest available")

			break

		elif npc.name.begins_with("Musician"):
			print("Talk to NPC")

			if npc.active_quest in self.active_bard_quests.keys():
				print("Already talked to this NPC")
				QUEST_LABEL.text = self.active_bard_quests[npc.active_quest].description
			elif npc.active_quest in self.finished_bard_quests:
				print("Finished bard quest")
				QUEST_LABEL.text = "Thanks for the help! Here you are a magical string"
			else:
				var quest = npc.try_get_quest()
				if quest:
					self.active_bard_quests[quest.id] = quest.data
					QUEST_LABEL.text = quest.data.description
				else:
					QUEST_LABEL.text = "I don't have any quests for you"
					print("No quest available")

			break


func get_save_data():
	return {
		"xp": xp,
		"health": health,
		"max_health": max_health,
		"quest_counter": quest_counter,
		"position": position,
		"finished_npc_quests": finished_npc_quests,
		"finished_bard_quests": finished_bard_quests,
		"active_npc_quests_names": active_npc_quests.keys(),
		"active_bard_quests_names": active_bard_quests.keys()
	}


func load_save_data(data):
	xp = data["xp"]
	health = data["health"]
	max_health = data["max_health"]
	quest_counter = data["quest_counter"]
	position = str2var("Vector2" + data["position"])
	finished_npc_quests = data["finished_npc_quests"]
	finished_bard_quests = data["finished_bard_quests"]
	active_npc_quests = data["active_npc_quests"]
	active_bard_quests = data["active_bard_quests"]


func _on_InteractionArea_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.get_parent().name == "Villages":
		emit_signal("village_entered", area.name)
