extends Node2D

onready var PLAYER = get_node("/root/Game/Player")


func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_M:
		self.visible = not self.visible


func _ready():
	for village in $Houses.get_children():
		village.visible = false

		var timer = Timer.new()
		timer.name = "Timer"
		timer.wait_time = 300
		timer.one_shot = true
		timer.connect("timeout", village, "_on_Timer_timeout")

		village.add_child(timer)


func _process(_delta):
	$Player.position = PLAYER.position / 24320 * 512


func _on_Player_village_entered(name: String):
	print("Player entered village: " + name + "")
	show_village(name)


func show_village(name: String):
	var village = $Houses.get_node(name)
	village.visible = true
	village.get_node("Timer").start()
