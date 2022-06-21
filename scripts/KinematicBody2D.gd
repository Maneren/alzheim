extends KinematicBody2D

var moving = 0
var player_entered = false


func _on_Area2D_area_shape_entered(_area_rid, area: Area2D, _area_shape_index, _local_shape_index):
	if area.owner.name == "Player":
		print("Player entered area")
		if area.owner.finished_bard_quests.size() == 4:
			print("Opening")
			moving = 1

			if not player_entered:
				area.owner.IMAGE_TEXT_WIZARD.visible = true
				area.owner.something_shown = true

			player_entered = true


func _on_Area2D_area_shape_exited(_area_rid, area: Area2D, _area_shape_index, _local_shape_index):
	if area.owner.name == "Player":
		print("Player exited area")
		print("Closing")
		moving = -1


func _process(delta):
	self.position.x += moving * delta * 200
	self.position.x = clamp(self.position.x, 0, 1024)
